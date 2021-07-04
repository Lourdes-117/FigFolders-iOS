//
//  AudioMessageCellUtility.swift
//  FigFolders
//
//  Created by Lourdes on 7/4/21.
//

import UIKit
import MessageKit
import NVActivityIndicatorView

extension AudioMessageCell {
    func addDownloadingIndicator() {
        let downloadIndicator = NVActivityIndicatorView(frame: playButton.bounds, type: .ballRotateChase, color: .white, padding: nil)
        downloadIndicator.backgroundColor = self.messageContainerView.backgroundColor
        downloadIndicator.startAnimating()
        playButton.addSubview(downloadIndicator)
    }
    
    func removeDownloadingIndicator() {
        playButton.subviews.forEach { view in
            if view as? NVActivityIndicatorView != nil {
                view.removeFromSuperview()
                return
            }
        }
    }
}
