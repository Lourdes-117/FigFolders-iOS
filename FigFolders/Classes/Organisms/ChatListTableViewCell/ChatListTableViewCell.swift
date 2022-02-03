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
    let viewModel = ChatListTableViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configureCell(userNameString: String?, cellType: ChatListCellType, latestMessage: UserLatestConversationModel? = nil) {
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
            usernameTopConstraint = usernameTopConstraint.getLayoutConstraintWithPriority(viewModel.lowPriority)
            usernameCenterConstraint = usernameCenterConstraint.getLayoutConstraintWithPriority(viewModel.highPriorityPriority)
        }
    }
    
    func setupMessageLabelColor(isRead: Bool) {
        recentMessage.textColor = viewModel.getMessageLabelColor(isRead: isRead) ?? UIColor()
        recentMessageDate.textColor = viewModel.getMessageLabelColor(isRead: isRead) ?? UIColor()
    }
}
