//
//  VoiceRecordingViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 7/3/21.
//

import UIKit
protocol VoiceRecordingDelegate: NSObjectProtocol {
    func sendAudioWithFileUrl(url: URL?, length: TimeInterval?)
}

enum VoiceRecordingStates {
    case readyToRecord
    case recording
    case readyToSend
    
    mutating func toggle() {
        switch self {
        case .readyToRecord:
            self = .recording
        case .recording:
            self = .readyToSend
        case .readyToSend:
            self = .readyToRecord
        }
    }
}

class VoiceRecordingViewModel {
    let fileName = "recordedAudio.m4a "
    var recordingState: VoiceRecordingStates = .readyToRecord
    let shadowOffset: CGSize = .zero
    let shadowColor = ColorPalette.greyscale4.color ?? UIColor()
    let shadowOpacity: Float = 1
    let shadowRadius: CGFloat = 5
    let playImage = UIImage(systemName: "play")
    let pausesImage = UIImage(systemName: "pause")
    
    var shouldHideDeleteButton: Bool {
        recordingState != .readyToSend
    }
    var isAudioPlaying = false
    
    var fileUrl: URL? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return path?.appendingPathComponent(fileName)
    }
    
    var playbackControlsAlpha: CGFloat {
        switch recordingState {
        case .readyToSend :
            return 1
        default:
            return 0
        }
    }
    
    var recordButtonTitle: String {
        switch recordingState {
        case .readyToRecord:
            return "Record"
        case .recording:
            return "Recording"
        case .readyToSend:
            return "Send"
        }
    }
    
    var pausePlayButtonImage: UIImage? {
        isAudioPlaying ? pausesImage: playImage
    }
}
