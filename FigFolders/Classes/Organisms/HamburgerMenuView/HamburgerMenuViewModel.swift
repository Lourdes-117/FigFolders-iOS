//
//  HamburgerMenuViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 5/17/21.
//

import Foundation

enum HamburgerMenuItemType: Int {
    case notifications = 0
    case myFiles = 1
    case trending
    case store
    case none
    
    func getTitle() -> String {
        switch self {
        case .notifications:
            return "Notifications"
        case .myFiles:
            return "My Files"
        case .trending:
            return "Trending"
        case .store:
            return "Store"
        case .none:
            return ""
        }
    }
    
    func getIconName() -> String {
        switch self {
        case .notifications:
            return "notifications_icon"
        case .myFiles:
            return "myfiles_icon"
        case .trending:
            return "trending_icon"
        case .store:
            return "store_icon"
        case .none:
            return ""
        }
    }
}

class HamburgerMenuViewModel {
    let viewProfileButtonTitle = "View Profile"
}
