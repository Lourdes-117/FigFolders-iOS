//
//  FigFileDisplayViewModel.swift
//  FigFileDisplayViewModel
//
//  Created by Lourdes on 9/14/21.
//

import UIKit
import AVKit

class FigFileDisplayViewModel {
    var figFile: FigFileModel?
    
    var fileType: DocumentPickerDocumentType? {
        DocumentPickerDocumentType(rawValue: figFile?.fileType ?? "")
    }
    
    func getView(frame: CGRect) -> UIView {
        guard let fileType = fileType else { return UIView() }
        switch fileType {
        case .image:
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.sd_setImage(with: figFile?.fileUrlAsUrl, completed: nil)
            return imageView
        case .video:
            let videoPlayer = VideoPlayerView(frame: frame)
            videoPlayer.setupVideoPlayer(videoUrl: figFile?.fileUrlAsUrl, thumbnailUrl: nil)
            return videoPlayer
        default:
            return UIView()
        }
    }
}
