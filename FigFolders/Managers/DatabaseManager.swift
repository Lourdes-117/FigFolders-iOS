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
            userDatabaseReference.setValue(userDetails.toDictionnary) { [weak self] error, _ in
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
    
    /// Check If Username Is Available
    func isUsernameAvailable(username: String, completion: @escaping (Bool) -> Void) {
        database.child(username).observeSingleEvent(of: .value) { snapshot in
            completion(!snapshot.exists())
        }
    }
}
