//
//  StringConstants.swift
//  FigFolders
//
//  Created by Lourdes on 5/14/21.
//

import Foundation

class StringConstants {
    static let shared = StringConstants()

    // Constants
    let regex = RegexConstants()
    let userDefaults = UserDefaultsConstants()
    let database = DatabaseConstants()
    let storage = StorageConstants()
}

struct RegexConstants {
    let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let name = "^[A-Za-z]\\w{1,29}$"
    let phoneNumber = "^(\\+\\d{1,2}\\s?)?1?\\-?\\.?\\s?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}$"
    let userName = "^[a-zA-Z0-9](_(?!(\\.|_))|\\.(?!(_|\\.))|[a-zA-Z0-9]){6,18}[a-zA-Z0-9]$"
}

struct UserDefaultsConstants: Loopable {
    let firstName = "firstName"
    let lastName = "lastName"
    let emailID = "emailID"
    let phoneNumber = "phoneNumber"
    let dateOfBirth = "dateOfBirth"
    let profilePicUrl = "profilePicurl"
    let userName = "userName"
}

struct DatabaseConstants {
    let usersArray = "users_array"
}

struct StorageConstants {
    let profilePicturePath = "profile_picture/"
}

func deleteAllUserDefaults() {
    var userDefaultsDict: [String: Any]? = nil
    do {
        userDefaultsDict = try StringConstants.shared.userDefaults.allProperties()
    } catch {
        debugPrint("UserDefaults Dict Not Iterable")
    }
    userDefaultsDict?.forEach { userDefault in
        guard let key = userDefault.value as? String else { return }
        UserDefaults.standard.removeObject(forKey: key)
    }
}
