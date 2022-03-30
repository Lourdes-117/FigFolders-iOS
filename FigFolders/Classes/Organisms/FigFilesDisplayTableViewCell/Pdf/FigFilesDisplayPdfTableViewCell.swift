//
//  FigFilesDisplayPdfTableViewCell.swift
//  FigFolders
//
//  Created by Lourdes on 1/18/22.
//

import UIKit

class FigFilesDisplayPdfTableViewCell: UITableViewCell, FigFilesDisplayTableViewCell {
    static let kCellId = "FigFilesDisplayPdfTableViewCell"
    weak var figFilesTableViewCellDelegate: FigFilesTableViewCellDelegate?
    weak var likeCommentShareDelegate: LikeCommentShareDelegate?
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var likeCommentShareView: LikeCommentShareView!
    @IBOutlet weak var figFileProfileView: FigFileProfileView!
    @IBOutlet weak var pdfImageView: UIImageView!
    let viewModel = FigFilesDisplayPdfTableViewModel()
    
    private func setupGestureRecognizer() {
        pdfImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapImageView))
        pdfImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func onTapImageView() {
        figFilesTableViewCellDelegate?.openFigFileLargeView(figFile: viewModel.figFile)
    }
    
}

// MARK: - Extension FigFIlesDisplayImageTableViewCell
extension FigFilesDisplayPdfTableViewCell {
    func setupCell(figFile: FigFileModel) {
        setupBlurView(isFree: figFile.isFree, ownerUserName: figFile.ownerUsername, purchasedUsers: figFile.purchasedUsers)
        viewModel.figFile = figFile
        likeCommentShareView.figFileModel = viewModel.figFile
        likeCommentShareView.delegate = likeCommentShareDelegate
        figFileProfileView.delegate = figFilesTableViewCellDelegate
        setupGestureRecognizer()
        figFileProfileView.setupView(figFile: figFile)
    }
}
