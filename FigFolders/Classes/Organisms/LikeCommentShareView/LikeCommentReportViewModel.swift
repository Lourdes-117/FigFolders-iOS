//
//  LikeCommentReportViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 9/25/21.
//

import UIKit

class LikeCommentReportViewModel {
    var figFileLikeModel: FigFileLikeModel = FigFileLikeModel()
    var figFileModel: FigFileModel?
    var isLiked = false
    let likedImage = UIImage(systemName: "hand.thumbsup.fill")
    let notLikedImage = UIImage(systemName: "hand.thumbsup")
    
    var likeButtonImage: UIImage? {
        isLiked ? likedImage : notLikedImage
    }
}
