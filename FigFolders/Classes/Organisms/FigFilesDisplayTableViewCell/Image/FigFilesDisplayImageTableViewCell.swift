//
//  FigFIlesDisplayImageTableViewCell.swift
//  FigFolders
//
//  Created by Lourdes on 1/18/22.
//

import UIKit

class FigFilesDisplayImageTableViewCell: UITableViewCell, FigFilesDisplayTableViewCell {
    var likeCommentShareDelegate: LikeCommentShareDelegate?
    
    static let kCellId = "FigFilesDisplayImageTableViewCell"
    weak var figFilesTableViewCellDelegate: FigFilesTableViewCellDelegate?
    
    @IBOutlet weak var likeCommentShareView: LikeCommentShareView!
    @IBOutlet weak var figFileProfileView: FigFileProfileView!
    @IBOutlet weak var figFileImageView: UIImageView!
    
    let viewModel = FigFilesDisplayImageTableViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupGestureRecognizer() {
        figFileImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapImageView))
        figFileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func onTapImageView() {
        figFilesTableViewCellDelegate?.openFigFileLargeView(figFile: viewModel.figFile)
    }
}

// MARK:- Extension FigFIlesDisplayImageTableViewCell
extension FigFilesDisplayImageTableViewCell {
    func setupCell(figFile: FigFileModel) {
        viewModel.figFile = figFile
        likeCommentShareView.delegate = likeCommentShareDelegate
        likeCommentShareView.figFileModel = viewModel.figFile
        setupGestureRecognizer()
        figFileProfileView.setupView(figFile: figFile)
        figFileImageView.sd_setImage(with: figFile.fileUrlAsUrl, completed: nil)
        figFileProfileView.delegate = figFilesTableViewCellDelegate
    }
}

