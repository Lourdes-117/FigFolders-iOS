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
            self?.profilePicture.sd_setImage(with: profilePicUrl, completed: nil)
        }
        fileOwnerName.text = viewModel.fileOwnerName
        profilePicture.setRoundedCorners()
    }
    
    @IBAction func onTapFollowButton(_ sender: Any) {
    }
    
    @IBAction func onTapProfileButton(_ sender: Any) {
        delegate?.openProfileDetailsPage(userNameToPopulate: viewModel.fileOwnerName)
    }
}
