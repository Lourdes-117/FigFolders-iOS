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
    let temporaryUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/figfolders.appspot.com/o/FigFiles%2Flour_din%2Fimage%2Fsecond?alt=media&token=d771e427-21d1-4007-891f-40252f6ecadb")!
    let videoURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/figfolders.appspot.com/o/messages%2Fvideos%2Fconversation_test_usertwo_1632426600301431_lour_din.mp4.mp4?alt=media&token=5063032b-4881-4f0f-ba2d-5f51b3cfd3d2")!
    
    var fileType: DocumentPickerDocumentType? {
        DocumentPickerDocumentType(rawValue: figFile?.fileType ?? "")
    }
    
    func getView(frame: CGRect) -> UIView {
        guard let fileType = fileType else { return UIView() }
        switch fileType {
        default:
            let videoPlayer = VideoPlayerView(frame: frame)
            videoPlayer.setupVideoPlayer(videoUrl: videoURL, thumbnailUrl: nil)
            return videoPlayer
        }
    }
}
