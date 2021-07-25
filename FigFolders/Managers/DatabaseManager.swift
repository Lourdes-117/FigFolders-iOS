//
//  DatabaseManager.swift
//  FigFolders
//
//  Created by Lourdes on 5/15/21.
//

import Foundation
import FirebaseDatabase
import CoreLocation
import MessageKit

final class DatabaseManager {
    private init() {
        let databaseRef = Database.database(url: "https://figfolders-default-rtdb.asia-southeast1.firebasedatabase.app")
        databaseRef.isPersistenceEnabled = true
        self.database = databaseRef.reference()
    }
    static let shared = DatabaseManager()
    
    private let database: DatabaseReference!
    
// MARK: - User Account Methods
    
    /// Saves User Details To RealTime Database
    func saveUsersData(userDetails: UserDetailsModel, completion: @escaping (Bool) -> Void) {
        let userDatabaseReference = database.child(userDetails.username)
        userDatabaseReference.observeSingleEvent(of: .value) { snapshot in
            // Check if user Exists
            guard snapshot.value != nil else {
                completion(false)
                return
            }
            
            // Save data if user does not exist
            userDatabaseReference.setValue(userDetails.toDictionary) { [weak self] error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                self?.appendInUserArray(userDetails: userDetails, completion: completion)
            }
        }
    }
    
    /// Gets The Username For Given Email ID
    func getUsernameForEmail(emailID: String, completion: @escaping (String?) -> Void) {
        database.child(StringConstants.shared.database.usersArray).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(),
                   let usersArray = (snapshot.value as? [[String: String]]) else {
                    completion(nil)
                    return
                   }
            let userDictSelected = usersArray.first { $0[emailID] != nil }
            guard let userDict = userDictSelected else {
                completion(nil)
                return
            }
            let userName = userDict[emailID]
            completion(userName)
        }
    }
    
    /// Get User Details For Username
    func getUserDetailsForUsername(username: String, completion: @escaping (UserDetailsModel?) -> Void) {
        database.child(username).observeSingleEvent(of: .value) { snapshot in
            guard let anyValue = snapshot.value,
                snapshot.exists() else { return }
            var personDetails: UserDetailsModel?
            do {
                let encodedDictionary = try JSONSerialization.data(withJSONObject: anyValue, options: [])
                personDetails = try JSONDecoder().decode(UserDetailsModel.self, from: encodedDictionary)
            } catch {
                debugPrint("Error Gettings UserDetails: ", error)
            }
            completion(personDetails)
        }
    }
    
    func updateDetailsOfUser(userDetails: UserDetailsModel, completion: @escaping (Bool)->Void) {
        
        if let existingEmailId = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.emailID) as? String {
            if userDetails.safeEmail != existingEmailId { // If Email Id changes, update mapping
                let userArrayRef = database.child(StringConstants.shared.database.usersArray)
                userArrayRef.observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard var userArray = snapshot.value as? [[String: String]],
                          let strongSelf = self else {
                        completion(false)
                        return
                    }
                    userArray.removeAll { user in
                        user[existingEmailId] != nil
                    }
                    let newUser = strongSelf.createUserMappingDictFrom(userDetails: userDetails)
                    userArray.append(newUser)
                    userArrayRef.setValue(userArray)
                }
            }
        }
        
        let userReference = database.child(userDetails.username)
        userReference.observeSingleEvent(of: .value) { snapshot in
            guard (snapshot.value as? [String: String])?.decodeDictAsClass(type: UserDetailsModel.self) != nil else {
                completion(false)
                return
            }
            userReference.setValue(userDetails.toDictionary) { error, _ in
                guard error != nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    /// Get List Of All Users
    func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child(StringConstants.shared.database.usersArray).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
    
    /// Check If Username Is Available
    func isUsernameAvailable(username: String, completion: @escaping (Bool) -> Void) {
        database.child(username).observeSingleEvent(of: .value) { snapshot in
            completion(!snapshot.exists())
        }
    }
    
// MARK: - User Account Helper Methods
    
    private func createUserMappingDictFrom(userDetails: UserDetailsModel) -> [String: String] {
        return [userDetails.safeEmail: userDetails.username]
    }
    
    /// Append In User Array
    private func appendInUserArray(userDetails: UserDetailsModel, completion: @escaping (Bool) -> Void) {
        let usersDatabaseReference = database.child(StringConstants.shared.database.usersArray)
        usersDatabaseReference.observeSingleEvent(of: .value) { [weak self] snapshot in
            if (!snapshot.exists()) { // If User Mapping Does Not Exist yet
                guard let stronSelf = self else { return }
                let userDictArray = [stronSelf.createUserMappingDictFrom(userDetails: userDetails)]
                usersDatabaseReference.setValue(userDictArray) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            } else { // If User Mapping Dict Exists Already
                guard var userArray = snapshot.value as? [[String: String]],
                      let strongSelf = self else {
                    completion(false)
                    return
                }
                let userDetails = strongSelf.createUserMappingDictFrom(userDetails: userDetails)
                userArray.append(userDetails)
                usersDatabaseReference.setValue(userArray)
                completion(true)
            }
        }
    }
    
//  MARK: - Conversation Methods
    
    /// Gets All Conversations Of Particular User. This method Observes Continuously
    func getAllConversationsOfUser(username: String, completion: @escaping (Result<[UserConversationsModel], Error>) -> Void) {
        let conversationsPath = "\(username)/\(StringConstants.shared.database.conversations)"
        database.child(conversationsPath).observe(.value) { snapshot in
            guard let anyValue = snapshot.value,
                snapshot.exists() else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            var conversationsObject: [UserConversationsModel]?
            do {
                let data = try JSONSerialization.data(withJSONObject: anyValue, options: [])
                let conversations = try JSONDecoder().decode([UserConversationsModel].self, from: data)
                conversationsObject = conversations
            } catch {
                debugPrint("Error Getting Conversations: ", error)
            }
            guard let conversations = conversationsObject else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(conversations))
        }
    }
    
    func conversationExistsAtUserNode(with targetUser: String, completion: @escaping (Result<String, Error>) -> Void ) {
        guard let currentUserEmail = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.emailID) as? String else {
            completion(.failure(DatabaseError.failedToFetch))
            return
        }
        // Create Reference For Target User
        let targetUserReference = database.child("\(targetUser)/\(StringConstants.shared.database.conversations)")
        targetUserReference.observeSingleEvent(of: .value) { snapshot in
            guard let targetUserConversations = (snapshot.value as? [[String: String]]).decodeDictAsClass(type: [UserConversationsModel].self) else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            // Search In Target User Conversations
            if let conversation = targetUserConversations.first(where: {
                guard let targetUserEmailOfOtherUser = $0.otherUserEmailID else { return false }
                return targetUserEmailOfOtherUser == currentUserEmail
            }) {
                // Conversation Id Found In Other User
                guard let conversationID = conversation.conversationID else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                completion(.success(conversationID))
                return
            }
        }
    }
    
    /// Creates A New Conversation With Target User
    func createNewConversation(with otherUserEmail: String, messageToSend: Message, otherUserName: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserName = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.userName) as? String,
              let currentUserEmail = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.emailID) as? String else {
            return
        }
        
        createNewConversationForUser(otherUserName, messageToSend, currentUserEmail, currentUserName) { [weak self] success in
            if success {
                self?.createNewConversationForUser(currentUserName, messageToSend, otherUserEmail, otherUserName) {
                    success in
                    completion(success)
                }
            } else {
                completion(success)
            }
        }
    }
    
    /// Send A Message To Target Conversation
    func sendMessage(conversationID: String, senderEmail: String, senderName: String, message: Message, receiverEmailId: String,
                            receiverName: String, existingConversationID: String?, completion: @escaping (Bool) -> Void) {
        //Add New Message To Conversation
        let conversationPath = "\(StringConstants.shared.database.conversations)/\(conversationID)/\(StringConstants.shared.database.messagesArray)"
        database.child(conversationPath).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var currentMessagesAnyValue = snapshot.value as? [Any?],
                snapshot.exists() else {
                completion(false)
                return
            }
            
            currentMessagesAnyValue.removeAll(where: { $0 == nil })
            
            var currentMessagesOptional: [MessageModel]?
            
            do {
                let data = try JSONSerialization.data(withJSONObject: currentMessagesAnyValue, options: [])
                let messages = try JSONDecoder().decode([MessageModel].self, from: data)
                currentMessagesOptional = messages
            } catch {
                debugPrint("Error Getting Messages: ", error)
                completion(false)
            }
            
            guard var currentMessages = currentMessagesOptional else {
                completion(false)
                return
            }
            
            let newMessage = MessageModel()
            newMessage.content = self?.getMessageString(message) ?? ""
            newMessage.date = message.sentDate.toDateString()
            newMessage.isRead = false
            newMessage.messageID = message.messageId
            newMessage.otherUserName = receiverName
            newMessage.senderName = senderName
            newMessage.type = message.kind.rawValue
            
            currentMessages.append(newMessage)
            
            var messagesDictionary = [[String: Any]]()
            for eachMessage in currentMessages {
                if let eachMessageDict = eachMessage.toDictionary {
                    messagesDictionary.append(eachMessageDict)
                }
            }
            
            self?.database.child("\(StringConstants.shared.database.conversations)/\(conversationID)/\(StringConstants.shared.database.messagesArray)").setValue(messagesDictionary, withCompletionBlock: { [weak self] error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                // Update Sender Latest Message
                self?.updateLatestMessageForUser(username: senderName, conversationID: conversationID, message: message, completion: { success in
                    // Latest Message Updated
                    if success {
                        completion(true)
                        return
                    }
                    
                    //Creating Latest Message

                    let currentUserConversationsReference = self?.database.child("\(senderName)/\(StringConstants.shared.database.conversations)")
                    currentUserConversationsReference?.observeSingleEvent(of: .value, with: { currentUserConversationsSnapshot in
                        if var currentUserConversations = currentUserConversationsSnapshot.value as? [[String: Any]] {
                            // Conversations Node Exists Under User
                            guard let newConversation = self?.createConversationNode(message, receiverEmailId, receiverName, overrideMessageID: existingConversationID) else {
                                completion(false)
                                return
                            }
                            currentUserConversations.append(newConversation)
                            currentUserConversationsReference?.setValue(currentUserConversations, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    completion(false)
                                    return
                                }
                                completion(true)
                            })
                        } else { // Conversations Node Does Not Exist Under User
                            guard let newConversation = self?.createConversationNode(message, receiverEmailId, receiverName, overrideMessageID: existingConversationID) else {
                                completion(false)
                                return
                            }
                            let newConversationArray = [newConversation]
                            currentUserConversationsReference?.setValue(newConversationArray, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                    completion(false)
                                    return
                                }
                                completion(true)
                            })
                        }
                    })
                    
                })
                
                // Update Recepient Latest Message
                self?.updateLatestMessageForUser(username: receiverName, conversationID: conversationID, message: message, completion: completion)
            })
        }
    }
    
// MARK: - Conversation Helper Methods
    /// Create A New Conversation For User
    private func createNewConversationForUser(_ currentUserName: String, _ messageToSend: Message, _ otherUserEmail: String, _ otherUserName: String, _ completion: @escaping (Bool) -> Void) {
        let reference = database.child(currentUserName)
        reference.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var userNode = (snapshot.value as? [String : Any]) else {
                completion(false)
                debugPrint("User Not Found")
                return
            }
            if var conversations = userNode[StringConstants.shared.database.conversations] as? [[String: Any]] {
                // Conversation Array Exists
                // Appending Messages
                guard let messageNode = self?.createConversationNode(messageToSend, otherUserEmail, otherUserName) else {
                    completion(false)
                    return
                }
                conversations.append(messageNode)
                userNode[StringConstants.shared.database.conversations] = conversations
                reference.setValue(userNode) { error, _ in
                    guard error == nil else {
                        debugPrint("Error In Writing Message To Database")
                        completion(false)
                        return
                    }
                    completion(true)
                }
                
            } else {
                // Conversation Array Does Not Exist
                // Creare Array
                userNode[StringConstants.shared.database.conversations] = [
                    self?.createConversationNode(messageToSend, otherUserEmail, otherUserName)
                ]
                reference.setValue(userNode) { [weak self] error, _ in
                    guard error == nil else {
                        debugPrint("Error In Writing Message To Database")
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(message: messageToSend, currentUserName: currentUserName, otherUserName: otherUserName, completion: completion)
                }
            }
        }
    }
    
    /// Get All Messages For A Given Conversation
    func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        database.child("\(StringConstants.shared.database.conversations)/\(id)/\(StringConstants.shared.database.messagesArray)").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]?] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let messages: [Message] = value.compactMap { dictionaryOptional in
                guard let dictionary = dictionaryOptional else{ return nil }
                var eachMessageOptional: MessageModel?
                do {
                    let eachMessageData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
                    let decodedMessage = try JSONDecoder().decode(MessageModel.self, from: eachMessageData)
                    eachMessageOptional = decodedMessage
                } catch {
                    debugPrint("Failed To Fetch All Messages: ",error)
                    completion(.failure(DatabaseError.failedToFetch))
                }
                guard let content = eachMessageOptional?.content,
                      let dateString = eachMessageOptional?.date,
                      let messageId = eachMessageOptional?.messageID,
                      let otherUserName = eachMessageOptional?.otherUserName,
                      let senderName = eachMessageOptional?.senderName,
                      let messageType = eachMessageOptional?.type,
                      let date = dateString.toDateObject() else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return nil
                }
                
                let sender = Sender(senderId: senderName, displayName: senderName, photoUrl: getProfilePicPathFromUsername(otherUserName))
                
                var messageKind: MessageKind?
                
                // Message Rendering On Screen
                if messageType == StringConstants.shared.messageKind.text { // Text Message
                    messageKind = .text(content)
                } else if messageType == StringConstants.shared.messageKind.photo { // Photo Message
                    guard let imageUrl = URL(string: content) else { return nil }
                    messageKind = .photo(Media(url: imageUrl, image: nil, placeholderImage: UIImage(named: "image_placeholder") ?? UIImage(), size: CGSize(width: 300, height: 300)))
                } else if messageType == StringConstants.shared.messageKind.video { // Video Message
                    guard let videoUrl = URL(string: content) else { return nil }
                    messageKind = .video(Media(url: videoUrl, image: nil, placeholderImage: UIImage(named: "video_placeholder") ?? UIImage(), size: CGSize(width: 300, height: 300)))
                } else if messageType == StringConstants.shared.messageKind.location { // Location Message
                    let locationComponents = content.components(separatedBy: ",")
                    guard let latitude = Double(locationComponents.first ?? ""),
                          let longitude = Double(locationComponents.last ?? "") else { return nil }
                    let location = Location(location: CLLocation(latitude: latitude, longitude: longitude), size: CGSize(width: 300, height: 300))
                    messageKind = .location(location)
                } else if messageType == StringConstants.shared.messageKind.audio {
                    guard let url = URL(string: content) else { return nil}
                    let audioItem = Audio(duration: 0, size: CGSize(width: 200, height: 50), url: url)
                    messageKind = .audio(audioItem)
                }
                
                guard let messageKind = messageKind else {
                    return Message(sender: sender, messageId: messageId, sentDate: date, kind: .text("Error Loading Message"))
                }
                
                return Message(sender: sender,
                               messageId: messageId,
                               sentDate: date,
                               kind: messageKind)
            }
            
            completion(.success(messages))
        }
    }
    
    /// Create A Conversation Node
    private func createConversationNode(_ message: Message, _ otherUserEmail: String, _ otherUserName: String, overrideMessageID: String? = nil) -> [String: Any] {
        let messageDate = message.sentDate.toDateString()
        
        let messageString = getMessageString(message)
        
        let newConversationData = UserConversationsModel()
        newConversationData.conversationID = overrideMessageID ?? message.messageId
        newConversationData.otherUserName = otherUserName
        newConversationData.otherUserEmailID = otherUserEmail
        
        let latestMessage = UserLatestConversationModel()
        latestMessage.type = message.kind.rawValue
        latestMessage.date = messageDate
        latestMessage.isRead = false
        latestMessage.message = messageString
        
        newConversationData.latestMessage = latestMessage
        
        return newConversationData.toDictionary ?? [String: Any]()
    }
    
    /// Get Message Text
    private func getMessageString(_ message: Message) -> String {
        var messageString = ""
        switch message.kind {
        
        case .text(let messageText):
            messageString = messageText
        case .attributedText(_):
            break
        case .photo(let mediaItem):
            if let urlString = mediaItem.url?.absoluteString {
                messageString = urlString
            }
        case .video(let mediaItem):
            if let urlString = mediaItem.url?.absoluteString {
                messageString = urlString
            }
        case .location(let locationData):
            let location = locationData.location
            messageString = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        case .emoji(_):
            break
        case .audio(let mediaItem):
            messageString = mediaItem.url.absoluteString
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        return messageString
    }
    
    private func finishCreatingConversation(message: Message, currentUserName: String, otherUserName: String, completion: @escaping (Bool) -> Void) {
        let messageModel = MessageModel()
        messageModel.content = getMessageString(message)
        messageModel.date = message.sentDate.toDateString()
        messageModel.isRead = false
        messageModel.messageID = message.messageId
        messageModel.otherUserName = otherUserName
        messageModel.senderName = currentUserName
        messageModel.type = message.kind.rawValue
        
        let messageDict = messageModel.toDictionary
        
        let value: [String: Any] = [
            StringConstants.shared.database.messagesArray: [
                messageDict
            ]
        ]
        
        let conversationPath = "\(StringConstants.shared.database.conversations)/\(message.messageId)"
        
        database.child(conversationPath).setValue(value) { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    private func updateLatestMessageForUser(username: String, conversationID: String, message: Message, completion: @escaping (Bool) -> Void) {
        //Update Sender Latest Message
        self.database.child("\(username)/\(StringConstants.shared.database.conversations)").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let senderConversationsAnyValue = snapshot.value,
                snapshot.exists() else {
                completion(false)
                return
            }
            
            var senderConversationsOptional: [UserConversationsModel]?
            
            do {
                let conversationsData = try JSONSerialization.data(withJSONObject: senderConversationsAnyValue, options: [])
                let conversations = try JSONDecoder().decode([UserConversationsModel].self, from: conversationsData)
                senderConversationsOptional = conversations
            } catch {
                debugPrint("Error Getting Conversations To Update: ", error)
                completion(false)
            }
            
            guard var senderConversations = senderConversationsOptional else {
                completion(false)
                return
            }
            
            var position = 0
            var targetConversation: UserConversationsModel?
            
            for conversationIterating in senderConversations {
                if let currentConversationID = conversationIterating.conversationID,
                   currentConversationID == conversationID {
                    targetConversation = conversationIterating
                    break
                }
                position += 1
            }
            
            let latestMesageUpdated = UserLatestConversationModel()
            latestMesageUpdated.message = self?.getMessageString(message) ?? ""
            latestMesageUpdated.type = message.kind.rawValue
            latestMesageUpdated.isRead = false
            latestMesageUpdated.date = message.sentDate.toDateString()
            
            targetConversation?.latestMessage = latestMesageUpdated
            guard let targetConversation = targetConversation else {
                completion(false)
                return
            }
            senderConversations[position] = targetConversation

            var senderConversationsDict = [[String: Any]]()
            for eachConversation in senderConversations {
                let eachConversationDict = eachConversation.toDictionary
                if let dict = eachConversationDict {
                    senderConversationsDict.append(dict)
                }
            }
            
            self?.database.child("\(username)/\(StringConstants.shared.database.conversations)").setValue( senderConversationsDict, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
        })
    }
}

// MARK:- Database Errors
public enum DatabaseError: Error {
    case failedToFetch
}
