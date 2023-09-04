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
        viewModel.commentId = comment.commentId ?? ""
        viewModel.indexPath = indexPath
        viewModel.commentUserName = comment.userName ?? ""
        userNameLabel.text = comment.userName
        commentTextView.text = comment.commentString
        commentTextView.delegate = self
        commentTextView.roundCorners(corners: [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 10)
        editButton.isHidden = !viewModel.isCommentFromCurrentUser
        editButton.roundCorners(corners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 8)
        disableCommentTextView()
        
        setupTapGestureRecognizer()
    }
    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openEditComment))
        commentTextView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func openEditComment() {
        delegate?.deselectSelectedText()
        if viewModel.isCommentFromCurrentUser {
            delegate?.editCommentWithCommentId(commentId: viewModel.commentId)
        }
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.deselectSelectedText()
    }
}
