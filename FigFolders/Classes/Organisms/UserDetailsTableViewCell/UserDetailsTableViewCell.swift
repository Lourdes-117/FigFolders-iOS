//
//  UserDetailsTableViewCell.swift
//  FigFolders
//
//  Created by Lourdes on 9/13/21.
//

import UIKit

class UserDetailsTableViewCell: UITableViewCell {
    static let kCellId = "UserDetailsTableViewCell"
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    weak var delegate: UserProfileViewDelegate?
    
    let viewModel = UserDetailsTableViewCellViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(userName: String) {
        viewModel.userName = userName
        setValues()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        profilePictureImageView.layer.borderColor = viewModel.profilePicBorderColor
    }
    
    private func setValues() {
        usernameLabel.text = viewModel.userName
        DatabaseManager.shared.getUserDetailsForUsername(username: viewModel.userName ?? "") { [weak self] userDetailsModel in
            guard let strongSelf = self else { return }
            strongSelf.userFullNameLabel.text = userDetailsModel?.fullName
            strongSelf.followersLabel.text = userDetailsModel?.followersString
            strongSelf.followingLabel.text = userDetailsModel?.followingString
        }
        StorageManager.shared.getProfilePicUrlForUser(userName: viewModel.userName ?? "") { [weak self] url in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.profilePicUrl = url
            strongSelf.profilePictureImageView.sd_setImage(with: url, placeholderImage: strongSelf.viewModel.profilePicPlaceholder, options: .forceTransition, completed: nil)
            strongSelf.profilePictureImageView.setRoundedCorners()
        }
        profilePictureImageView.setRoundedCorners()
        profilePictureImageView.layer.borderWidth = viewModel.profildPicBorderWidth
        profilePictureImageView.layer.borderColor = viewModel.profilePicBorderColor
        profilePictureImageView.isUserInteractionEnabled = true
        let profilePicTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapProfileView))
        profilePictureImageView.addGestureRecognizer(profilePicTapGesture)
    }
    
    @objc private func onTapProfileView() {
        delegate?.openProfileIconView(profilePicUrl: viewModel.profilePicUrl)
    }
}
