//
//  CommentsViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 1/23/22.
//

import Foundation

class CommentsViewModel {
    let pageTitle = "Comments"
    let numberOfCells = 6
    var isCommentBeingEditted = false
    
    var numberOfSections: Int {
        isCommentBeingEditted ? 2 : 1
    }
}
