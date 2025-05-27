//
//  CommentsTableViewCellViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 2/17/22.
//

import Foundation

class CommentsTableViewCellViewModel {
    let notLikedImageName = "hand.thumbsup"
    let likedImageName = "hand.thumbsup.fill"
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var commentId = ""
    var commentUserName = ""
    
    var isCommentFromCurrentUser: Bool {
        commentUserName == currentUserUsername
    }
}

protocol CommentTableViewDelegate: AnyObject {
    func didBeginEdittingCommentAtIndexpath(indexPath: IndexPath)
    func deselectSelectedText()
    func editCommentWithCommentId(commentId: String)
}
