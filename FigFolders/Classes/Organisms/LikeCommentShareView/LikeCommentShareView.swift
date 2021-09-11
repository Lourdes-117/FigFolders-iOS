//
//  LikeCommentShareView.swift
//  FigFolders
//
//  Created by Lourdes on 9/11/21.
//

import UIKit

protocol LikeCommentShareDelegate: AnyObject {
    func onTapLike()
    func onTapComment()
    func onTapShare()
}

class LikeCommentShareView: UIView {
    private let nibName = "LikeCommentShareView"
    
    weak var delegate: LikeCommentShareDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit(nibName)
    }
    
    @IBAction func onTapLikeButton(_ sender: Any) {
        delegate?.onTapLike()
    }
    
    @IBAction func onTapCommentButton(_ sender: Any) {
        delegate?.onTapComment()
    }
    
    @IBAction func onTapShareButton(_ sender: Any) {
        delegate?.onTapShare()
    }
}
