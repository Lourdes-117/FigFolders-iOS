//
//  FigFileProfileView.swift
//  FigFolders
//
//  Created by Lourdes on 1/18/22.
//

import UIKit

class FigFileProfileView: UIView {
    private let nibName = "FigFileProfileView"
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var fileOwnerName: UILabel!
    @IBOutlet weak var followButton: UIButton!
    weak var delegate: FigFilesTableViewCellDelegate?
    let viewModel = FigFileProfileViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(nibName)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(nibName)
    }
    
    func setupView(figFile: FigFileModel) {
        viewModel.figFile = figFile
        StorageManager.shared.getProfilePicUrlForUser(userName: viewModel.fileOwnerName) { [weak self] profilePicUrl in
            self?.profilePicture.sd_setImage(with: profilePicUrl, placeholderImage: UIImage(systemName: "person.circle"))
        }
        fileOwnerName.text = viewModel.fileOwnerName
        profilePicture.setRoundedCorners()
        viewModel.isFollowed = figFile.isUserFollowing ?? false
        setupFollowButton()
    }
    
    private func setupFollowButton() {
        // No need to follow self user
        followButton.isHidden = currentUserUsername == viewModel.fileOwnerName
        // Set title based on follow status
        followButton.setTitle(viewModel.followButtonText, for: .normal)
    }
    
    @IBAction func onTapFollowButton(_ sender: Any) {
        CloudFunctionsManager.shared.followOrUnfollowUser(userNameToFollow: viewModel.fileOwnerName)
        delegate?.followOrUnfollowUser(userNameToFollowOrUnfollow: viewModel.fileOwnerName)
        viewModel.isFollowed.toggle()
        setupFollowButton()
    }
    
    @IBAction func onTapProfileButton(_ sender: Any) {
        delegate?.onTapProfileIcon(userNameToPopulate: viewModel.fileOwnerName)
    }
}
