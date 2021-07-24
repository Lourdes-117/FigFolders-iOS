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
    private let recordImage = UIImage(named: "microphone_icon")
    private let stopRecordImage = UIImage(named: "stop_icon")
    private let playIcon = UIImage(named: "play_icon")
    private let pauseIcon = UIImage(named: "pause_icon")
    let timeIntervalToUpdateSlider: TimeInterval = 0.1
    let maxRecordingTimeLimit: TimeInterval = 120
    private let lightThemAccentColor = ColorPalette.primary_green.color
    private let darkThemeAccentColor = ColorPalette.greyscale6.color
    
    var shouldHideDeleteButton: Bool {
        recordingState != .readyToSend
    }
    var audioPlayerPausedTime: TimeInterval = 0
    var isAudioPlaying = false
    
    var fileUrl: URL? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return path?.appendingPathComponent(fileName)
    }
    
    var playPauseIcon: UIImage? {
        isAudioPlaying ? pauseIcon : playIcon
    }
    
    var playbackControlsAlpha: CGFloat {
        switch recordingState {
        case .readyToSend :
            return 1
        default:
            return 0
        }
    }
    
    var recordControlsAlpha: CGFloat {
        switch recordingState {
        case .readyToRecord, .recording :
            return 1
        default:
            return 0
        }
    }
    
    var recordingTitle: String {
        switch recordingState {
        case .readyToRecord:
            return "Tap to start recording"
        case .recording:
            return "Tap to stop recording"
        case .readyToSend:
            return ""
        }
    }
    
    var recordButtonImage: UIImage? {
        switch recordingState {
        case .readyToRecord:
            return recordImage
        case .recording:
            return stopRecordImage
        case .readyToSend:
            return nil
        }
    }
    
    func getAccentColor(for theme: UIUserInterfaceStyle) -> UIColor? {
        switch theme {
        case .light:
        return lightThemAccentColor
        case .dark:
        return darkThemeAccentColor
        default:
            return nil
        }
    }
    
    func getSendTextColor(for theme: UIUserInterfaceStyle) -> UIColor? {
        switch theme {
        case .light:
            return LabelColorPalette.labelColorPrimary.color
        case .dark:
            return LabelColorPalette.labelColorGreen.color
        default:
            return nil
        }
    }
}
