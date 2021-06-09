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
    
    @IBOutlet weak var usernameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameCenterConstraint: NSLayoutConstraint!
    let viewModel = ChatListTableViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configureCell(userNameString: String?, cellType: ChatListCellType) {
        setupCellType(cellType: cellType)
        
        guard let userNameString = userNameString else { return }
        userName.text = userNameString
        DatabaseManager.shared.getUserDetailsForUsername(username: userNameString) { [weak self] userDetailsModel in
            guard let userDetails = userDetailsModel else { return }
            let profilePicUrl = URL(string: userDetails.profilePicUrl)
            self?.profilePic.sd_setImage(with: profilePicUrl, completed: nil)
        }
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
            usernameTopConstraint = usernameTopConstraint.getLayoutConstraintWithPriority(viewModel.lowPriority)
            usernameCenterConstraint = usernameCenterConstraint.getLayoutConstraintWithPriority(viewModel.highPriorityPriority)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
