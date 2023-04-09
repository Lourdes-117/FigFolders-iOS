//
//  ChatViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 6/15/21.
//

import Foundation
import MessageKit
import CoreLocation
import AVFoundation
import UIKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

extension MessageKind {
    var rawValue: String {
        switch self {
        case .text(_):
            return StringConstants.shared.messageKind.text
        case .attributedText(_):
            return StringConstants.shared.messageKind.attributedText
        case .photo(_):
            return StringConstants.shared.messageKind.photo
        case .video(_):
            return StringConstants.shared.messageKind.video
        case .location(_):
            return StringConstants.shared.messageKind.location
        case .emoji(_):
            return StringConstants.shared.messageKind.emoji
        case .audio(_):
            return StringConstants.shared.messageKind.audio
        case .contact(_):
            return StringConstants.shared.messageKind.contact
        case .linkPreview(_):
            return StringConstants.shared.messageKind.linkPreview
        case .custom(_):
            return StringConstants.shared.messageKind.custom
        }
    }
    
    var mediaUrl: String? {
        switch self {
        case .audio(let audioItem):
            return audioItem.url.absoluteString
        case .video(let videoItem):
            return videoItem.url?.absoluteString
        case .photo(let mediaItem):
            return mediaItem.url?.absoluteString
        default:
            return nil
        }
    }
}

struct Location: LocationItem {
    var location: CLLocation
    var size: CGSize
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    var photoUrl: String
}

struct Media: MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
}

struct Audio: AudioItem {
    var duration: Float
    var size: CGSize
    var url: URL
}

class ChatViewControllerViewModel {
    
    // Input View
    let inputBarButtonIcon = UIImage(systemName: "plus")
    let attachMediaTitle = "Attach Media"
    let attachMediaMessage = "What Would You Like To Attach"
    let photo = "Photo"
    let video = "Video"
    let audio = "Audio"
    let location = "Location"
    let cancel = "Cancel"
    
    // Attaching Media
    let attachPhotoTitle = "Attach Photo"
    let attachPhotoMessage = "Where Would You Like To Attach Photo From"
    let camera = "Camera"
    let photoLibrary = "Photo Library"
    let attachVideoTitle = "Attach Video"
    let attachVideoMessage = "Where Would You Like To Attach Video From"
    let mediaTypeForVideo = "public.movie"
    let videoQualityType: UIImagePickerController.QualityType = .typeMedium
    let videoMaxLength = TimeInterval(120)
    
    // Segue Identifiers
    let imageViewerSegueIdentifier = "ImageViewerViewControllerSegue"
    
    // Selected Message
    var selectedImageUrl: URL?
    var selectedVideoUrl: URL?
    var selectedAudioDuration: TimeInterval?
    var audioDurationPlayed: TimeInterval?
    var audioProgress: TimeInterval {
        (audioDurationPlayed ?? 0)/(selectedAudioDuration ?? 0)
    }
        
    var selectedAudioCell: AudioMessageCell?
    
    // Accounts
    var receiverName: String = ""
    var receiverEmail: String = ""
    var conversationID: String?
    var isNewConversation: Bool {
        return conversationID == nil
    }
    
    // Avatar
    let avatarStringStartingIndexForAvatar = 0
    let avatarStringEndingIndexForAvatar = 2
    
    let senderEmail = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.emailID) as? String
    let senderName = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.userName) as? String ?? ""
    
    var selfSender: Sender? {
        let username = senderName
        let profilePicurl = getProfilePicPathFromUsername(username)
        return Sender(senderId: username, displayName: username, photoUrl: profilePicurl)
    }
    
    func generateMessageID() -> String? {
        let dateString = Date().timeIntervalSince1970.description.replacingOccurrences(of: ".", with: "")
        let messageId = "conversation_\(receiverName)_\(dateString)_\(senderName)".replacingOccurrences(of: " ", with: "")
        debugPrint("Generated Message ID: \(messageId)")
        return messageId
    }
}
