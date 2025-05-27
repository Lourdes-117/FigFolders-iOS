//
//  LikeCommentReportView.swift
//  FigFolders
//
//  Created by Lourdes on 9/11/21.
//

import UIKit

protocol LikeCommentReportDelegate: AnyObject {
    func onTapLike(figFileLikeModel: FigFileLikeModel?)
    func onTapComment(figFileModel: FigFileModel?)
    func onTapReport(figFileModel: FigFileModel?)
}

class LikeCommentReportView: UIView {
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    private let nibName = "LikeCommentReportView"
    
    let viewModel = LikeCommentReportViewModel()
    
    weak var delegate: LikeCommentReportDelegate?
    
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
            if let numberOfLikes = figFileModel?.likedUsers?.count,
               numberOfLikes > 0 {
                likeButton.setTitle(String(numberOfLikes), for: .normal)
            }
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
        if viewModel.isLiked { // liking
            let numberOfLikes = (figFileModel?.likedUsers?.count ?? 0) + 1
            likeButton.setTitle(String(numberOfLikes), for: .normal)
        } else { // disliking
            var likedUsers = figFileModel?.likedUsers ?? []
            likedUsers.removeAll(where: {$0 == currentUserUsername})
            let numberOfLikes = likedUsers.count
            if numberOfLikes > 0 {
                likeButton.setTitle(String(numberOfLikes), for: .normal)
            } else {
                likeButton.setTitle("", for: .normal)
            }
        }
    }
    
    @IBAction func onTapCommentButton(_ sender: Any) {
        delegate?.onTapComment(figFileModel: figFileModel)
    }
    
    @IBAction func onTapShareButton(_ sender: Any) {
        delegate?.onTapReport(figFileModel: figFileModel)
    }
}
