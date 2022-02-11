//
//  ChatListTableViewCell.swift
//  FigFolders
//
//  Created by Lourdes on 6/9/21.
//

import UIKit
import SDWebImage

class ChatListTableViewCell: UITableViewCell {
    static let kIdentifier = "ChatListTableViewCell"
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var recentMessage: UILabel!
    @IBOutlet weak var recentMessageDate: UILabel!
    
    @IBOutlet weak var usernameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var recentMessageContentPreviewImageView: UIImageView!
    @IBOutlet weak var recentMessageContentPreviewImageAspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var recentMessageContentAndPreviewImageHorizontalSpace: NSLayoutConstraint!
    @IBOutlet weak var recentMessageContentPreviewImageWidthConstraint: NSLayoutConstraint!
    let viewModel = ChatListTableViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configureCell(userNameString: String?, cellType: ChatListCellType, latestMessage: UserLatestConversationModel? = nil) {
        viewModel.latestMessage = latestMessage
        setupCellType(cellType: cellType)
        guard let userNameString = userNameString else { return }
        userName.text = userNameString
        recentMessage.text = latestMessage?.recentMessageString
        recentMessageDate.text = latestMessage?.date
        DatabaseManager.shared.getUserDetailsForUsername(username: userNameString) { [weak self] userDetailsModel in
            guard let userDetails = userDetailsModel else { return }
            let profilePicUrl = URL(string: userDetails.profilePicUrl)
            self?.profilePic.sd_setImage(with: profilePicUrl, placeholderImage: self?.viewModel.profilePlaceholderImage)
        }
        setupContentPreviewImage()
        setupMessageLabelColor(isRead: latestMessage?.isRead ?? false)
    }
    
    private func setupView() {
        profilePic.setRoundedCorners()
    }
    
    private func setupCellType(cellType: ChatListCellType) {
        switch cellType {
        case .chatList:
            usernameTopConstraint = usernameTopConstraint.getLayoutConstraintWithPriority(viewModel.highPriorityPriority)
            usernameCenterConstraint = usernameCenterConstraint.getLayoutConstraintWithPriority(viewModel.lowPriority)
        case .chatSearch:
            recentMessage.isHidden = true
            recentMessageDate.isHidden = true
            recentMessageContentPreviewImageView.isHidden = true
            usernameTopConstraint = usernameTopConstraint.getLayoutConstraintWithPriority(viewModel.lowPriority)
            usernameCenterConstraint = usernameCenterConstraint.getLayoutConstraintWithPriority(viewModel.highPriorityPriority)
        }
    }
    
    private func setupContentPreviewImage() {
        if viewModel.shouldShowContentPreviewImage {
            recentMessageContentPreviewImageView.image = UIImage(systemName: viewModel.contentPreviewImageName)
            recentMessageContentPreviewImageView.isHidden = false
            recentMessageContentPreviewImageAspectRatioConstraint = recentMessageContentPreviewImageAspectRatioConstraint.getLayoutConstraintWithPriority(1000)
            recentMessageContentPreviewImageWidthConstraint = recentMessageContentPreviewImageWidthConstraint.getLayoutConstraintWithPriority(1)
            recentMessageContentAndPreviewImageHorizontalSpace.constant = 5
        } else {
            recentMessageContentPreviewImageAspectRatioConstraint = recentMessageContentPreviewImageAspectRatioConstraint.getLayoutConstraintWithPriority(1)
            recentMessageContentPreviewImageWidthConstraint = recentMessageContentPreviewImageWidthConstraint.getLayoutConstraintWithPriority(1000)
            recentMessageContentAndPreviewImageHorizontalSpace.constant = 0
        }
    }
    
    func setupMessageLabelColor(isRead: Bool) {
        recentMessage.textColor = viewModel.getMessageLabelColor(isRead: isRead) ?? UIColor()
        recentMessageDate.textColor = viewModel.getMessageLabelColor(isRead: isRead) ?? UIColor()
        recentMessageContentPreviewImageView.tintColor = viewModel.getMessageLabelColor(isRead: isRead) ?? UIColor()
    }
}
