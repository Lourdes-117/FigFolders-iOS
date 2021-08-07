//
//  UserDetailsModel.swift
//  FigFolders
//
//  Created by Lourdes on 5/15/21.
//

import Foundation

// MARK: - User Details Model
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

// MARK: - User Conversations Model
class UserConversationsModel: Encodable, Decodable {
    var latestMessage: UserLatestConversationModel?
    var conversationID: String?
    var otherUserName: String?
    var otherUserEmailID: String?
}

// MARK: - User Latest Conversation Model
class UserLatestConversationModel: Encodable, Decodable {
    var type: String?
    var date: String?
    var isRead: Bool?
    var message: String?
    
    var recentMessageString: String? {
        guard let messageType = type else { return message }
        if messageType == MessageKindConstant().text { return message }
        else if messageType == MessageKindConstant().audio { return MessageKindConstant().audio }
        else if messageType == MessageKindConstant().video { return MessageKindConstant().video }
        else if messageType == MessageKindConstant().photo { return MessageKindConstant().photo }
        else if messageType == MessageKindConstant().location { return MessageKindConstant().location }
        return message
    }
}

// MARK: - Message Model
class MessageModel: Encodable, Decodable {
    var content: String?
    var date: String?
    var isRead: Bool?
    var messageID: String?
    var otherUserName: String?
    var senderName: String?
    var type: String?
}

// MARK: - Fig File Model
struct FigFileModel: Encodable, Decodable {
    let ownerUsername: String?
    let fileName: String?
    let fileType: String?
    let fileDescription: String?
    let likedUsers: [String?]
    var fileUrl: String?
    let filePrice: Float?
    let comments: [FigFilesCommentsModel?]
    var fileSizeBytes: Int?
    
    
    var isFree: Bool {
        return filePrice ?? 0 <= 0
    }
}

// MARK: - Fig File Comment
struct FigFilesCommentsModel: Encodable, Decodable {
    var username: String?
    var comment: String?
}
