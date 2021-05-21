//
//  UserDetailsModel.swift
//  FigFolders
//
//  Created by Lourdes on 5/15/21.
//

import Foundation

struct UserDetailsModel: Encodable, Decodable {
    init(firstNameString: String, lastNameString: String, dateOfBirthString: String, phoneNumberString: String, emailIDString: String, usernameString: String) {
        firstName = firstNameString
        lastName = lastNameString
        dateOfBirth = dateOfBirthString
        phoneNumber = phoneNumberString
        username = usernameString
        safeEmail = UserDetailsModel.getSafeEmail(email: emailIDString)
        profilePicUrl = ""
    }
    
    var firstName: String
    var lastName: String
    var dateOfBirth: String
    var phoneNumber: String
    var username: String
    var safeEmail: String
    var profilePicUrl: String
    
    static func getSafeEmail(email: String) -> String {
        let edittedEmail = email.replacingOccurrences(of: "@", with: "^")
        return edittedEmail.replacingOccurrences(of: ".", with: "~")
    }
    
    static func getProperEmail(safeEmail: String) -> String {
        let edittedEmail = safeEmail.replacingOccurrences(of: "^", with: "@")
        return edittedEmail.replacingOccurrences(of: "~", with: ".")
    }
}
