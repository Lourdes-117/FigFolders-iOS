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
    weak var LikeCommentReportDelegate: LikeCommentReportDelegate?
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var LikeCommentReportView: LikeCommentReportView!
    @IBOutlet weak var figFileProfileView: FigFileProfileView!
    @IBOutlet weak var pdfImageView: UIImageView!
    let viewModel = FigFilesDisplayPdfTableViewModel()
    
    private func setupGestureRecognizer() {
        pdfImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapImageView))
        pdfImageView.addGestureRecognizer(tapGestureRecognizer)
        
        blurView.isUserInteractionEnabled = true
        let blurViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapPurchaseBlurView))
        blurView.addGestureRecognizer(blurViewTapGestureRecognizer)
    }
    
    @objc func onTapImageView() {
        figFilesTableViewCellDelegate?.openFigFileLargeView(figFile: viewModel.figFile, shouldShowPurchaseScreen: false)
    }
    
    @objc func onTapPurchaseBlurView() {
        figFilesTableViewCellDelegate?.openFigFileLargeView(figFile: viewModel.figFile, shouldShowPurchaseScreen: true)
    }
}

// MARK: - Extension FigFIlesDisplayImageTableViewCell
extension FigFilesDisplayPdfTableViewCell {
    func setupCell(figFile: FigFileModel) {
        setupBlurView(isFree: figFile.isFree, ownerUserName: figFile.ownerUsername, purchasedUsers: figFile.purchasedUsers)
        viewModel.figFile = figFile
        LikeCommentReportView.figFileModel = viewModel.figFile
        LikeCommentReportView.delegate = LikeCommentReportDelegate
        figFileProfileView.delegate = figFilesTableViewCellDelegate
        setupGestureRecognizer()
        figFileProfileView.setupView(figFile: figFile)
    }
}
