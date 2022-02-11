//
//  ChatListTableViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 6/10/21.
//

import Foundation
import UIKit
import MessageKit

enum ChatListCellType {
    case chatSearch
    case chatList
}

class ChatListTableViewModel {
    let lowPriority: Float = 1
    let highPriorityPriority: Float = 1000
    let profilePlaceholderImage = UIImage(systemName: "person.circle.fill")?.withTintColor(.lightGray)
    private let readMessageLabelColor = LabelColorPalette.labelColorSecondary.color
    private let unreadMessageLabelColor = LabelColorPalette.labelColorPrimary.color
    var latestMessage: UserLatestConversationModel?
    
    func getMessageLabelColor(isRead: Bool) -> UIColor? {
        isRead ? readMessageLabelColor : unreadMessageLabelColor
    }
    
    var shouldShowContentPreviewImage: Bool {
        guard let messageTypeString = latestMessage?.type else { return false}
        return (messageTypeString == StringConstants.shared.messageKind.photo
        || messageTypeString == StringConstants.shared.messageKind.video
        || messageTypeString == StringConstants.shared.messageKind.audio
        || messageTypeString == StringConstants.shared.messageKind.location
        || messageTypeString == StringConstants.shared.messageKind.contact)
    }
    
    var contentPreviewImageName: String {
        guard let messageTypeString = latestMessage?.type,
              shouldShowContentPreviewImage else { return "" }
        if messageTypeString == StringConstants.shared.messageKind.photo { return "photo" }
        if messageTypeString == StringConstants.shared.messageKind.video { return "video" }
        if messageTypeString == StringConstants.shared.messageKind.audio { return "speaker.fill" }
        if messageTypeString == StringConstants.shared.messageKind.location { return "location.fill" }
        if messageTypeString == StringConstants.shared.messageKind.contact { return "person.text.rectangle.fill" }
        return ""
    }
}
