//
//  FigFileTableViewCell.swift
//  FigFolders
//
//  Created by Lourdes on 9/11/21.
//

import UIKit

class FigFilesTableViewCell: UITableViewCell {
    static let kCellId = "FigFilesTableViewCell"
    
    @IBOutlet weak var likeCommetShareView: LikeCommentShareView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var fileOwnerNameLabel: UILabel!
    @IBOutlet weak var fileTitleLabel: UILabel!
    
    let viewModel = FigFilesTableViewCellViewModel()
    
    func setupCell(figFile: FigFileModel, indexPath: IndexPath) {
        viewModel.figFile = figFile
        viewModel.indexPath = indexPath
        setDetails()
        setupDelegate()
    }
    
    private func setDetails() {
        profilePicture.setRoundedCorners()
        fileOwnerNameLabel.text = viewModel.ownerName
        StorageManager.shared.getProfilePicUrlForUser(userName: viewModel.ownerName) { [weak self] ownerProfilePicUrl in
            guard let strongSelf = self else { return }
            self?.profilePicture.sd_setImage(with: ownerProfilePicUrl, placeholderImage: strongSelf.viewModel.profilePicPlaceholder, options: .forceTransition, completed: nil)

        }
        fileTitleLabel.text = viewModel.fileTitle
    }
    
    private func setupDelegate() {
        likeCommetShareView.delegate = self
    }
    
    @IBAction func onTapFollowButton(_ sender: Any) {
    }
}

extension FigFilesTableViewCell: LikeCommentShareDelegate {
    func onTapLike() {
        
    }
    
    func onTapComment() {
        
    }
    
    func onTapShare() {
        
    }
}
