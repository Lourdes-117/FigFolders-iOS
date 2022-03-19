//
//  CommentsViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 1/23/22.
//

import Foundation

class CommentsViewModel {
    var figFileModel: FigFileModel?
    var pagination = 0
    let pageTitle = "Comments"
    var comments: [FigFilesCommentsModel] = [FigFilesCommentsModel]()
    var numberOfCells: Int {
        return comments.count
    }
    
    func getCommentModelAtIndexpath(indexPath: IndexPath) -> FigFilesCommentsModel? {
        return comments.getObjectSafely(indexPath.row)
    }
    
    func getCommentsWithPagination(completion: @escaping () -> Void) {
        CloudFunctionsManager.shared.getFigFileComments(fileOwner: figFileModel?.ownerUsername ?? "",
                                                        fileUrl: figFileModel?.fileUrl ?? "",
                                                        paginationIndex: pagination) { [weak self] result in
            switch result {
            case .success(let commentsReturned):
                if !commentsReturned.isEmpty {
                    self?.pagination += 1
                    self?.comments.append(contentsOf: commentsReturned)
                } else {
                    self?.comments.append(contentsOf: commentsReturned)
                }
            case .failure(_):
                break
            }
            completion()
        }
    }
    
    func isCommentFromCurrentUser(row: Int) -> Bool {
        return comments.getObjectSafely(row)?.userName == currentUserUsername
    }
}
