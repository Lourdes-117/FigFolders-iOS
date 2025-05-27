//
//  FigFileProfileViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 1/18/22.
//

import Foundation

class FigFileProfileViewModel {
    private let followText = "+ Follow"
    private let unfollowText = "- Unfollow"
    var figFile: FigFileModel?
    
    var fileOwnerName: String {
        figFile?.ownerUsername ?? ""
    }
    
    var isFollowed: Bool = false // Call setupFollowButton in viewController for UI updates
    
    var followButtonText: String {
        isFollowed ? unfollowText : followText
    }
}
