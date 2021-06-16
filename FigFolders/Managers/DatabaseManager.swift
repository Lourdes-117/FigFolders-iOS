//
//  DatabaseManager.swift
//  FigFolders
//
//  Created by Lourdes on 5/15/21.
//

import Foundation
import FirebaseDatabase

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
            guard let anyValue = snapshot.value else { return }
            var personDetails: UserDetailsModel?
            do {
                let encodedDictionary = try JSONSerialization.data(withJSONObject: anyValue, options: [])
                personDetails = try JSONDecoder().decode(UserDetailsModel.self, from: encodedDictionary)
            } catch {
                debugPrint("Error: ", error)
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
    
//  MARK: - Conversation Methods
    
    /// Gets All Conversations Of Particular User. This method Observes Continuously
    func getAllConversationsOfUser(username: String, completion: @escaping (Result<[UserConversationsModel], Error>) -> Void) {
        let conversationsPath = "\(username)/\(StringConstants.shared.database.conversations)"
        database.child(conversationsPath).observe(.value) { snapshot in
            guard let conversationDictArray = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            var conversations = [UserConversationsModel]()
            conversationDictArray.forEach { userDict in
                let conversation = UserConversationsModel()
                conversation.latestMessage = UserLatestConversationModel()
                let latestDict = userDict[StringConstants.shared.database.latestMessage] as? [String: Any]
                conversation.conversationID = userDict[StringConstants.shared.database.conversationID] as? String
                conversation.otherUserName = userDict[StringConstants.shared.database.otherUserName] as? String
                conversation.otherUserEmailID = userDict[StringConstants.shared.database.otherUserEmailID] as? String
                conversation.latestMessage?.date = latestDict?[StringConstants.shared.database.date] as? String
                conversation.latestMessage?.isRead = latestDict?[StringConstants.shared.database.isRead] as? Bool
                conversation.latestMessage?.message = latestDict?[StringConstants.shared.database.message] as? String
                conversations.append(conversation)
                
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
        
        createNewConversationForUser(currentUserName, messageToSend, otherUserEmail, otherUserName) { [weak self] success in
            if success {
                let currentUserName = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.userName) as? String ?? ""
                self?.createNewConversationForUser(otherUserName, messageToSend, currentUserEmail, currentUserName) {
                    success in
                    completion(success)
                }
            } else {
                completion(success)
            }
        }
    }
    
    /// Create A New Conversation For User
    fileprivate func createNewConversationForUser(_ currentUserName: String, _ messageToSend: Message, _ otherUserEmail: String, _ otherUserName: String, _ completion: @escaping (Bool) -> Void) {
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
                    let currentUserName = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.userName) as? String ?? ""
                    self?.finishCreatingConversation(message: messageToSend, currentUserName: currentUserName, otherUserName: otherUserName, completion: completion)
                }
            }
        }
    }
    
    private func createConversationNode(_ message: Message, _ otherUserEmail: String, _ otherUserName: String, overrideMessageID: String? = nil) -> [String: Any] {
        let messageDate = message.sentDate.toDateString()
        
        let messageString = getMessageString(message)
        
        let newConversationData = UserConversationsModel()
        newConversationData.conversationID = overrideMessageID ?? message.messageId
        newConversationData.otherUserName = otherUserName
        newConversationData.otherUserEmailID = otherUserEmail
        
        let latestMessage = UserLatestConversationModel()
        latestMessage.date = messageDate
        latestMessage.isRead = false
        latestMessage.message = messageString
        
        newConversationData.latestMessage = latestMessage
        
        return newConversationData.toDictionary ?? [String: Any]()
    }
    
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
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
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
}

// MARK:- Database Errors
public enum DatabaseError: Error {
    case failedToFetch
}
