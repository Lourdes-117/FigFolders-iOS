//
//  AddCommentViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 2/18/22.
//

import Foundation

class AddCommentViewModel {
    var commentModel: FigFilesCommentsModel?
    let areYouSureTitle = "Are You Sure"
    let yesText = "Yes"
    let noText = "No"
    var pageTitle: String {
        if isCommentEditMode {
            return "Edit Comment"
        } else {
            return "Add Comment"
        }
    }
    var areYouSureMessage: String {
        if isCommentEditMode {
            return "Are You Sure You Want To Abandom Your Changes"
        } else {
            return "Are You Sure You Want To Abandom Your Comment"
        }
    }
    
    var isCommentEditMode: Bool {
        return commentModel != nil
    }
    
    var commentString: String {
        return commentModel?.commentString ?? ""
    }
}
