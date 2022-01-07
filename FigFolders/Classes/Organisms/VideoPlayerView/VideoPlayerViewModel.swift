//
//  VideoPlayerViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 9/23/21.
//

import UIKit
import WebKit

class VideoPlayerViewModel {
    var isVideoPlaying = false
    let playIconImage = UIImage(named: "play_icon")
    let pauseIconImage = UIImage(named: "pause_icon")
    
    var playPauseButtonImage: UIImage? {
        isVideoPlaying ? pauseIconImage : playIconImage
    }
    
    private var lastTimeToHideRegistered = Date()
    var shouldInturruptControlHiding: Bool {
        get {
            return lastTimeToHideRegistered.timeIntervalSinceNow <= -3 ? false : true
        }
        set {
            if newValue {
                lastTimeToHideRegistered = Date()
            } else {
                lastTimeToHideRegistered.addTimeInterval(-3)
            }
        }
    }
}
