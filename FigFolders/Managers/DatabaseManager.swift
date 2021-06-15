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
            guard let personDetails = (snapshot.value as? [String: String])?.decodeDictAsClass(type: UserDetailsModel.self) else {
                completion(nil)
                return
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
            guard let conversations = (snapshot.value as? [[String: String]])?.decodeDictAsClass(type: [UserConversationsModel].self) else {
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
}

// MARK:- Database Errors
public enum DatabaseError: Error {
    case failedToFetch
}
