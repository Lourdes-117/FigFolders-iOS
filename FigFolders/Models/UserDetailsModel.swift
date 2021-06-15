//
//  UserDetailsModel.swift
//  FigFolders
//
//  Created by Lourdes on 5/15/21.
//

import Foundation

struct UserDetailsModel: Encodable, Decodable {
    init(firstNameString: String, lastNameString: String, dateOfBirthString: String, phoneNumberString: String, emailIDString: String, usernameString: String, profilePicUrlString: String) {
        firstName = firstNameString
        lastName = lastNameString
        dateOfBirth = dateOfBirthString
        phoneNumber = phoneNumberString
        username = usernameString
        safeEmail = UserDetailsModel.getSafeEmail(email: emailIDString)
        profilePicUrl = profilePicUrlString
    }
    
    var firstName: String
    var lastName: String
    var dateOfBirth: String
    var phoneNumber: String
    var username: String
    var safeEmail: String
    var profilePicUrl: String
    
    var conversations: [UserConversationsModel?]?
    
    static func getSafeEmail(email: String) -> String {
        let edittedEmail = email.replacingOccurrences(of: "@", with: "^")
        return edittedEmail.replacingOccurrences(of: ".", with: "~")
    }
    
    static func getProperEmail(safeEmail: String) -> String {
        let edittedEmail = safeEmail.replacingOccurrences(of: "^", with: "@")
        return edittedEmail.replacingOccurrences(of: "~", with: ".")
    }
}

class UserConversationsModel: Encodable, Decodable {
    var latestmessage: UserLatestConversationModel?
    var conversationID: String?
    var otherUserName: String?
    var otherUserEmailID: String?
}

class UserLatestConversationModel: Encodable, Decodable {
    var date: String?
    var isRead: Bool?
    var message: String?
}
