//
//  AcPlayerOnUIView.swift
//  FigFolders
//
//  Created by Lourdes on 9/24/21.
//

import UIKit
import AVKit

// Reference: https://stackoverflow.com/questions/41978143/place-avplayerviewcontroller-inside-uiview?noredirect=1&lq=1

class AVPlayerOnUIView: UIView {
    var videoEndNotification: NSObjectProtocol?
    
    weak var delegate: AVPlayerOnUIViewVideoDelegate?
    let viewModel = AVPlayerOnUIViewModel()
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }

        set {
            playerLayer.player = newValue
            videoEndNotification = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                   object: nil,
                                                   queue: nil) { [weak self] _ in
                newValue?.seek(to: CMTime.zero)
                self?.delegate?.didEndVideo()
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapPlayer))
            self.addGestureRecognizer(tapGesture)
        }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var isPlaying: Bool {
        return ((player?.rate != 0) && (player?.error == nil))
    }
    
    @objc private func onTapPlayer() {
        delegate?.onTapVideoPlayer()
    }
    
    deinit {
        guard let observer = videoEndNotification else { return }
        NotificationCenter.default.removeObserver(observer)
    }
}
