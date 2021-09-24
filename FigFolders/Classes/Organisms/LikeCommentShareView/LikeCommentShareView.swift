//
//  LikeCommentShareView.swift
//  FigFolders
//
//  Created by Lourdes on 9/11/21.
//

import UIKit

protocol LikeCommentShareDelegate: AnyObject {
    func onTapLike(shouldLike: Bool)
    func onTapComment()
    func onTapShare()
}

class LikeCommentShareView: UIView {
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    private let nibName = "LikeCommentShareView"
    
    let viewModel = LikeCommentShareViewModel()
    
    weak var delegate: LikeCommentShareDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit(nibName)
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
        delegate?.onTapLike(shouldLike: viewModel.isLiked)
    }
    
    @IBAction func onTapCommentButton(_ sender: Any) {
        delegate?.onTapComment()
    }
    
    @IBAction func onTapShareButton(_ sender: Any) {
        delegate?.onTapShare()
    }
}
