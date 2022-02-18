//
//  AddCommentViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 2/18/22.
//

import Foundation

class AddCommentViewModel {
    var fileOwner: String?
    var fileUrl: String?
    var indexPath: IndexPath?
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
    
    func addComment(newCommentString: String, completion: @escaping (Bool) -> Void) {
        if isCommentEditMode {
            
        } else {
            let addCommentModel = AddCommentModel()
            addCommentModel.fileUrl = fileUrl
            addCommentModel.commentString = newCommentString
            addCommentModel.fileOwner = fileOwner
            addCommentModel.userName = currentUserUsername
            addCommentModel.commentId = generateCommentID()
            addCommentModel.commentAddedDate = Date().toDateString()
            
            CloudFunctionsManager.shared.addCommentsForFile(addCommentModel: addCommentModel, completion: completion)
        }
    }
    
    private func generateCommentID() -> String? {
        let dateString = Date().timeIntervalSince1970.description.replacingOccurrences(of: ".", with: "")
        let commentId = "comment_\(fileOwner ?? "")_\(dateString)_\(currentUserUsername ?? "")".replacingOccurrences(of: " ", with: "")
        debugPrint("Generated Comment ID: \(commentId)")
        return commentId
    }
}
