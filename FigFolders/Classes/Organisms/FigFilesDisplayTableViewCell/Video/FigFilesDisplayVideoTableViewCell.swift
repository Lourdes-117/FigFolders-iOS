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
    
    @IBOutlet weak var likeCommentShareView: LikeCommentShareView!
    @IBOutlet weak var figFileProfileView: FigFileProfileView!
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    
    let viewModel = FigFilesDisplayVideoTableViewModel()
}

// MARK:- Extension FigFIlesDisplayImageTableViewCell
extension FigFilesDisplayVideoTableViewCell {
    func setupCell(figFile: FigFileModel) {
        viewModel.figFile = figFile
        likeCommentShareView.figFileModel = viewModel.figFile
        likeCommentShareView.delegate = likeCommentShareDelegate
        figFileProfileView.delegate = figFilesTableViewCellDelegate
        figFileProfileView.setupView(figFile: figFile)
        videoPlayerView.setupVideoPlayer(videoUrl: viewModel.figFile?.fileUrlAsUrl, thumbnailUrl: nil)
    }
}
