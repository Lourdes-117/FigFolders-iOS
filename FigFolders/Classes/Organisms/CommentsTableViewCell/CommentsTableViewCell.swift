//
//  CommentsTableViewCell.swift
//  FigFolders
//
//  Created by Lourdes on 2/17/22.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var editButton: UIButton!
    
    static let kCellId = "CommentsTableViewCell"
    
    let viewModel = CommentsTableViewCellViewModel()
    
    weak var delegate: CommentTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(comment: FigFilesCommentsModel, indexPath: IndexPath) {
        viewModel.indexPath = indexPath
        userNameLabel.text = comment.userName
        commentTextView.text = comment.commentString
        commentTextView.delegate = self
        commentTextView.roundCorners(corners: [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 10)
        editButton.isHidden = comment.userName != currentUserUsername
        disableCommentTextView()
    }
    
    private func disableCommentTextView() {
        commentTextView.isEditable = false
        commentTextView.sizeToFit()
        commentTextView.isScrollEnabled = false
    }
    
    private func enableCommentTextView() {
        commentTextView.isEditable = true
        commentTextView.sizeToFit()
        commentTextView.isScrollEnabled = true
        commentTextView.becomeFirstResponder()
    }
    
    @IBAction func onTapEditButton(_ sender: Any) {
        delegate?.didBeginEdittingCommentAtIndexpath(indexPath: viewModel.indexPath)
    }
}

extension CommentsTableViewCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didEndEdittingCommentAtIndexpath(indexPath: viewModel.indexPath)
    }
}
