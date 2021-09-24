//
//  VideoPlayerView.swift
//  FigFolders
//
//  Created by Lourdes on 9/23/21.
//

import UIKit
import AVKit

class VideoPlayerView: UIView {
    private let nibName = "VideoPlayerView"
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var videoControlsView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }

        set {
            playerLayer.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var videoPlayer: AVPlayerOnUIView?
    
    let viewModel = VideoPlayerViewModel()
    
// MARK: - Lifecycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(nibName)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(nibName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit(nibName)
    }
    
    func setupVideoPlayer(videoUrl: URL?, thumbnailUrl: URL?) {
        guard let videoUrl = videoUrl else { return }
        let player = AVPlayer(url: videoUrl)
        let playerFrame = backgroundView.bounds
        videoPlayer = AVPlayerOnUIView(frame: playerFrame)
        videoPlayer?.delegate = self
        videoPlayer?.player = player
        
        setupTapGestureRecognizerOnVideoControlsView()
        
        backgroundView.addSubview(videoPlayer ?? AVPlayerOnUIView(frame: playerFrame))
        
        videoPlayer?.translatesAutoresizingMaskIntoConstraints = false
        videoPlayer?.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        videoPlayer?.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        videoPlayer?.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        videoPlayer?.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
    }
    
// MARK: - Helper Methods
    private func initiateHidingVideoControlTimer() {
        viewModel.shouldInturruptControlHiding = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.hidePlayerControlsWithAnimation()
        }
    }
    
    private func hidePlayerControlsWithAnimation() {
        if viewModel.isVideoPlaying && !viewModel.shouldInturruptControlHiding {
            UIView.animateKeyframes(withDuration: kAnimationDuration, delay: 0) {
                self.videoControlsView.alpha = 0
            } completion: { [weak self] _ in
                self?.videoControlsView.isHidden = true
            }
        }
    }
    
    private func showPlayerControlsWithAnimation() {
        UIView.animate(withDuration: kAnimationDuration) { [weak self] in
            self?.videoControlsView.isHidden = false
            self?.videoControlsView.alpha = 1
        }
        initiateHidingVideoControlTimer()
    }
    
    private func setupTapGestureRecognizerOnVideoControlsView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapControlsView))
        videoControlsView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func onTapControlsView() {
        guard let isVideoPlaying = videoPlayer?.isPlaying else { return }
        if isVideoPlaying {
            viewModel.shouldInturruptControlHiding = false
            hidePlayerControlsWithAnimation()
        }
    }

// MARK: - Button Actions
    @IBAction func onTapButton(_ sender: Any) {
        guard let isVideoPlaying = videoPlayer?.isPlaying else { return }
        if isVideoPlaying {
            videoPlayer?.player?.pause()
        } else {
            videoPlayer?.player?.play()
            initiateHidingVideoControlTimer()
        }
        viewModel.isVideoPlaying = !isVideoPlaying // !isVideoPlaying cuz video playing state changed in previous command
        playPauseButton.setImage(viewModel.playPauseButtonImage, for: .normal)
    }
}

// MARK: - AVPlayer On UIView Video Delegate
extension VideoPlayerView: AVPlayerOnUIViewVideoDelegate {
    func didEndVideo() {
        showPlayerControlsWithAnimation()
        viewModel.isVideoPlaying = false
        playPauseButton.setImage(viewModel.playPauseButtonImage, for: .normal)
    }
    
    func onTapVideoPlayer() {
        showPlayerControlsWithAnimation()
    }
}
