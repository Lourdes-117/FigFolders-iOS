//
//  FigFilesDisplayVideoTableViewCell.swift
//  FigFolders
//
//  Created by Lourdes on 1/18/22.
//

import UIKit

class FigFilesDisplayVideoTableViewCell: UITableViewCell, FigFilesDisplayTableViewCell {
    static let kCellId = "FigFilesDisplayVideoTableViewCell"
    weak var figFilesTableViewCellDelegate: FigFilesTableViewCellDelegate?
    var likeCommentShareDelegate: LikeCommentShareDelegate?
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var likeCommentShareView: LikeCommentShareView!
    @IBOutlet weak var figFileProfileView: FigFileProfileView!
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    
    let viewModel = FigFilesDisplayVideoTableViewModel()
    
    private func setupGestureRecognizer() {
        blurView.isUserInteractionEnabled = true
        let blurViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapPurchaseBlurView))
        blurView.addGestureRecognizer(blurViewTapGestureRecognizer)
    }
    
    @objc func onTapPurchaseBlurView() {
        figFilesTableViewCellDelegate?.openFigFileLargeView(figFile: viewModel.figFile, shouldShowPurchaseScreen: true)
    }
}

// MARK: - Extension FigFIlesDisplayImageTableViewCell
extension FigFilesDisplayVideoTableViewCell {
    func setupCell(figFile: FigFileModel) {
        setupBlurView(isFree: figFile.isFree, ownerUserName: figFile.ownerUsername, purchasedUsers: figFile.purchasedUsers)
        viewModel.figFile = figFile
        likeCommentShareView.figFileModel = viewModel.figFile
        likeCommentShareView.delegate = likeCommentShareDelegate
        figFileProfileView.delegate = figFilesTableViewCellDelegate
        figFileProfileView.setupView(figFile: figFile)
        videoPlayerView.setupVideoPlayer(videoUrl: viewModel.figFile?.fileUrlAsUrl, thumbnailUrl: nil)
        setupGestureRecognizer()
    }
}
