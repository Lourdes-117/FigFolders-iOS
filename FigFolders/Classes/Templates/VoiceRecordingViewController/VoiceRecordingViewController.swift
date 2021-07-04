//
//  VoiceRecordingViewController.swift
//  FigFolders
//
//  Created by Lourdes on 7/3/21.
//

import UIKit
import AVFoundation

class VoiceRecordingViewController: UIViewController {
// MARK: - Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playbackControlsContainerView: UIView!
    
    let viewModel = VoiceRecordingViewModel()
    
    var delegate: VoiceRecordingDelegate?
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    let recordingSession = AVAudioSession.sharedInstance()
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    private func initialSetup() {
        setupViews()
        requestAudioPermission()
    }
    
    private func setupViews() {
        recordButton.setRoundedCorners()
        deleteButton.setRoundedCorners()
        playButton.setRoundedCorners()
        playbackControlsContainerView.alpha = 0
        recordButton.addShadow(offset: viewModel.shadowOffset, color: viewModel.shadowColor, opacity: viewModel.shadowOpacity, radius: viewModel.shadowRadius)
        deleteButton.addShadow(offset: viewModel.shadowOffset, color: viewModel.shadowColor, opacity: viewModel.shadowOpacity, radius: viewModel.shadowRadius)
        playButton.addShadow(offset: viewModel.shadowOffset, color: viewModel.shadowColor, opacity: viewModel.shadowOpacity, radius: viewModel.shadowRadius)
    }
    
    private func requestAudioPermission() {
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .videoRecording)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { isAllowed in
                DispatchQueue.main.async { [weak self] in
                    guard isAllowed else {
                        debugPrint("Microphhone Access Not Allowed")
                        return
                    }
                    self?.setupVoiceRecorder()
                }
            }
        } catch {
            debugPrint("Error Getting Microphone Permission \(error)")
        }
    }
    
    private func setupVoiceRecorder() {
        do {
            guard let fileUrl = viewModel.fileUrl else { return }
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: fileUrl, settings: settings)
            audioRecorder?.delegate = self
        } catch {
            debugPrint("Error Setting up Voice Recorder \(error)")
        }
    }
    
    private func setupAudioPlayer() {
        do {
            guard let fileUrl = viewModel.fileUrl else { return }
            audioPlayer = try AVAudioPlayer(contentsOf: fileUrl)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 10
        } catch {
            debugPrint("Error Setting up Audio Player \(error)")
        }
    }
    
// MARK: - helper Methods
    private func setViewForRecordingState() {
        UIView.animate(withDuration: kAnimationDuration) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.playbackControlsContainerView.alpha = strongSelf.viewModel.playbackControlsAlpha
        }
        playButton.setImage(viewModel.pausePlayButtonImage, for: .normal)
        recordButton.setTitle(viewModel.recordButtonTitle, for: .normal)
    }
    
    private func sendAudio() {
        setupAudioPlayer()
        delegate?.sendAudioWithFileUrl(url: viewModel.fileUrl, length: audioPlayer?.duration)
        navigationController?.popViewController(animated: true)
    }

// MARK: - Button Tap Actions
    @IBAction func onTapRecordButton(_ sender: Any) {
        viewModel.recordingState.toggle()
        switch viewModel.recordingState {
        case .recording:
            audioRecorder?.record()
        case .readyToSend:
            audioRecorder?.stop()
        case .readyToRecord:
            sendAudio()
        }
        setViewForRecordingState()
    }
    
    @IBAction func onTapPlayPauseButton(_ sender: Any) {
        viewModel.isAudioPlaying.toggle()
        if viewModel.isAudioPlaying {
            setupAudioPlayer()
            audioPlayer?.play()
        } else {
            audioPlayer?.pause()
        }
        setViewForRecordingState()
    }
    
    @IBAction func onTapDeleteButton(_ sender: Any) {
        guard let filePath = viewModel.fileUrl else { return }
        if FileManager.default.fileExists(atPath: filePath.absoluteString) {
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch {
                debugPrint("Error Deleting File \(error)")
            }
        }
        viewModel.recordingState = .readyToRecord
        audioPlayer?.stop()
        viewModel.isAudioPlaying = false
        setViewForRecordingState()
    }
}


// MARK: - Audio Recorder Delegate
extension VoiceRecordingViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        debugPrint("Audio Recording Finished")
    }
}

// MARK: - Audio Player Delegate
extension VoiceRecordingViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        debugPrint("Audio Playing Finished")
        viewModel.isAudioPlaying = false
        setViewForRecordingState()
    }
}
