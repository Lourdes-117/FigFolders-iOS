//
//  StringConstants.swift
//  FigFolders
//
//  Created by Lourdes on 5/14/21.
//

import Foundation

class StringConstants {
    static let shared = StringConstants()

    private init() { }
  
    // Constants
    let regex = RegexConstants()
    let userDefaults = UserDefaultsConstants()
    let database = DatabaseConstants()
    let storage = StorageConstants()
    let messageKind = MessageKindConstant()
    let figFiles = FigFilesConstants()
    let httpMethodConstants = HttpMethodConstants()
}

///Use Through StringConstants shared Instance
struct RegexConstants {
    let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let name = "([a-zA-Z]{3,30}\\s*)+"
    let phoneNumber = "^(\\+\\d{1,2}\\s?)?1?\\-?\\.?\\s?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}$"
    let userName = "^[a-zA-Z0-9](_(?!(\\.|_))|\\.(?!(_|\\.))|[a-zA-Z0-9]){6,18}[a-zA-Z0-9]$"
}

///Use Through StringConstants shared Instance
struct UserDefaultsConstants: Loopable {
    let firstName = "firstName"
    let lastName = "lastName"
    let emailID = "emailID"
    let phoneNumber = "phoneNumber"
    let dateOfBirth = "dateOfBirth"
    let profilePicUrl = "profilePicurl"
    let userName = "userName"
}

///Use Through StringConstants shared Instance
struct DatabaseConstants {
    let usersArray = "users_array"
    let conversations = "conversations"
    let conversationID = "conversationID"
    let messagesArray = "messages"
    let otherUserEmailID = "otherUserEmailID"
    let messageType = "type"
    let otherUserName = "otherUserName"
    let latestMessage = "latestMessage"
    let date = "date"
    let isRead = "isRead"
    let message = "message"
    let userDetails = "user_details"
  
    func userDetailsPath(user: String) -> String {
      return "\(userDetails)/\(user)"
    }
}

///Use Through StringConstants shared Instance
struct FigFilesConstants {
    let figFilesPath = "FigFiles/"
    
    var currentUserFigFilesPath: String {
        return "\(figFilesPath)\(currentUserUsername ?? "")/"
    }
}

///Use Through StringConstants shared Instance
struct StorageConstants {
    let profilePicturePath = "profile_picture/"
    let messageImagesPath = "messages/images/"
    let messageVideosPath = "messages/videos/"
    let messageAudioPath = "messages/audios/"
    let videoExtension = ".mp4"
}

struct MessageKindConstant {
    let text = "text"
    let attributedText = "attributedText"
    let photo = "photo"
    let video = "video"
    let location = "location"
    let emoji = "emoji"
    let audio = "audio"
    let contact = "contact"
    let linkPreview = "linkPreview"
    let custom = "custom"
}

struct HttpMethodConstants {
    let applicationJson = "application/json"
    let contentType = "Content-Type"
    let postMethod = "POST"
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
