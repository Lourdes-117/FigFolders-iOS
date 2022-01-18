//
//  LikeCommentShareView.swift
//  FigFolders
//
//  Created by Lourdes on 9/11/21.
//

import UIKit

protocol LikeCommentShareDelegate: AnyObject {
    func onTapLike(figFileLikeModel: FigFileLikeModel?)
    func onTapComment(figFileModel: FigFileModel?)
    func onTapShare(figFileModel: FigFileModel?)
}

class LikeCommentShareView: UIView {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    private let nibName = "LikeCommentShareView"
    
    let viewModel = LikeCommentShareViewModel()
    
    weak var delegate: LikeCommentShareDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(nibName)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(nibName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit(nibName)
    }

    var figFileModel: FigFileModel? {
        didSet {
            viewModel.figFileModel = figFileModel
            viewModel.figFileLikeModel.fileUrl = viewModel.figFileModel?.fileUrl
            viewModel.figFileLikeModel.fileOwner = viewModel.figFileModel?.ownerUsername
            viewModel.figFileLikeModel.currentUser = currentUserUsername
            
            isLiked = figFileModel?.likedUsers?.contains(currentUserUsername ?? "") ?? false
        }
    }
    
    var isLiked: Bool {
        set {
            viewModel.isLiked = newValue
            likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        }
        
        get {
            viewModel.isLiked
        }
    }
    
    @IBAction func onTapLikeButton(_ sender: Any) {
        viewModel.isLiked.toggle()
        isLiked = viewModel.isLiked
        delegate?.onTapLike(figFileLikeModel: viewModel.figFileLikeModel)
    }
    
    @IBAction func onTapCommentButton(_ sender: Any) {
        delegate?.onTapComment(figFileModel: figFileModel)
    }
    
    @IBAction func onTapShareButton(_ sender: Any) {
        delegate?.onTapShare(figFileModel: figFileModel)
    }
}
