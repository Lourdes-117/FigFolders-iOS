//
//  FigFIlesDisplayImageTableViewCell.swift
//  FigFolders
//
//  Created by Lourdes on 1/18/22.
//

import UIKit

class FigFilesDisplayImageTableViewCell: UITableViewCell, FigFilesDisplayTableViewCell {
    static let kCellId = "FigFilesDisplayImageTableViewCell"
    weak var figFilesTableViewCellDelegate: FigFilesTableViewCellDelegate?
    
    @IBOutlet weak var likeCommentShareView: LikeCommentShareView!
    @IBOutlet weak var figFileProfileView: FigFileProfileView!
    @IBOutlet weak var figFileImageView: UIImageView!
    
    let viewModel = FigFilesDisplayImageTableViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// MARK:- Extension FigFIlesDisplayImageTableViewCell
extension FigFilesDisplayImageTableViewCell {
    func setupCell(figFile: FigFileModel) {
        viewModel.figFile = figFile
        figFileProfileView.setupView(figFile: figFile)
        figFileImageView.sd_setImage(with: figFile.fileUrlAsUrl, completed: nil)
        figFileProfileView.delegate = figFilesTableViewCellDelegate
    }
}

extension FigFilesDisplayImageTableViewCell: LikeCommentShareDelegate {
    func onTapLike(shouldLike: Bool) {
        let figFileLikeModel = FigFileLikeModel()
        figFileLikeModel.currentUser = currentUserUsername
        figFileLikeModel.fileUrl = viewModel.fileUrlString
        figFileLikeModel.fileOwner = viewModel.ownerName
        CloudFunctionsManager.shared.likePostByUser(figFileLikeModel: figFileLikeModel)
    }
    
    func onTapComment() {
        
    }
    
    func onTapShare() {
        
    }
}

