//
//  CommentsViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 1/23/22.
//

import Foundation

class CommentsViewModel {
    var pagination = 0
    let pageTitle = "Comments"
    let numberOfCells = 6
    
    func getCommentModelAtIndexpath(indexPath: IndexPath) -> FigFilesCommentsModel {
        return FigFilesCommentsModel(userName: "bhjhfhvxbgh", commentString: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown pr PageMaker including versions of Lorem Ipsum.", commentAddedDate: "", commentId: "")
    }
}
