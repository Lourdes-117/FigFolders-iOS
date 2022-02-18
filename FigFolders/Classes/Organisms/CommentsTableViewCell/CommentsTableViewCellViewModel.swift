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
}

protocol CommentTableViewDelegate: AnyObject {
    func didBeginEdittingCommentAtIndexpath(indexPath: IndexPath)
}
