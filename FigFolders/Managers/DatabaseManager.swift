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
            userDatabaseReference.setValue(userDetails.toDictionnary) { error, _ in
                guard error == nil else {
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
