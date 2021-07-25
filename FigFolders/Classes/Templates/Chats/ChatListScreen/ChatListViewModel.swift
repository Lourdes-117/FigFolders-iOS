//
//  ChatListViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 6/5/21.
//

import UIKit

class ChatListViewModel {
    let navigationTitleColor = LabelColorPalette.labelColorPrimary.color ?? UIColor()
    let navigationBarColor = ColorPalette.primary_green.color
    let title = "Chats"
    let composeMessageImage = UIImage(systemName: "square.and.pencil")
    
    var conversations: [UserConversationsModel] = [UserConversationsModel]()
    
    var numberOfConversations: Int {
        get {
            return conversations.count
        }
    }
    
    func getConversationIdForUsername(username: String) -> String? {
        let selectedConversation = conversations.first(where: { $0.otherUserName == username })
        return selectedConversation?.conversationID
    }
    
    func getConversationIdAtIndex(_ index: Int) -> String? {
        return conversations[index].conversationID
    }
    
    func getUsernameAtIndex(_ index: Int) -> String? {
        return conversations[index].otherUserName
    }
    
    func getEmailIDAtIndex(_ index: Int) -> String? {
        return conversations[index].otherUserEmailID
    }
}
