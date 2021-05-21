//
//  DatabaseManager.swift
//  FigFolders
//
//  Created by Lourdes on 5/15/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database(url: "https://figfolders-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    
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
    
    /// Check If Username Is Available
    func isUsernameAvailable(username: String, completion: @escaping (Bool) -> Void) {
        database.child(username).observeSingleEvent(of: .value) { snapshot in
            completion(!snapshot.exists())
        }
    }
}
