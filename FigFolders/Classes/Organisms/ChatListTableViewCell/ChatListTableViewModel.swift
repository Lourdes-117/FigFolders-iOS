//
//  ChatListTableViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 6/10/21.
//

import Foundation
import UIKit

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
    
    func getMessageLabelColor(isRead: Bool) -> UIColor? {
        isRead ? readMessageLabelColor : unreadMessageLabelColor
    }
}
