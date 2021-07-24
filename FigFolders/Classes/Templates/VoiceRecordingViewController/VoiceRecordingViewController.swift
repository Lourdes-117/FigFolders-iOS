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
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var playbackControlsContainerView: UIView!
    @IBOutlet weak var recordContainerView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var recordTitle: UILabel!
    @IBOutlet weak var timelineSlider: UISlider!
    @IBOutlet weak var sliderEndTime: UILabel!
    
    let viewModel = VoiceRecordingViewModel()
    
    var delegate: VoiceRecordingDelegate?
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    let recordingSession = AVAudioSession.sharedInstance()
    
    private var audioProgressUpdateTimer: Timer?
    private var audioRecordingMaxLengthTimer: Timer?
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    private func initialSetup() {
        setupViews()
        requestAudioPermission()
        setupViewForTheme(for: self.traitCollection.userInterfaceStyle)
    }
    
    private func setupViews() {
        timelineSlider.value = 0
        recordButton.setRoundedCorners()
        sendButton.setRoundedCorners()
        cancelButton.setRoundedCorners()
        playPauseButton.setRoundedCorners()
        playbackControlsContainerView.alpha = 0
        recordButton.addShadow(offset: viewModel.shadowOffset, color: viewModel.shadowColor, opacity: viewModel.shadowOpacity, radius: viewModel.shadowRadius)
        sendButton.addShadow(offset: viewModel.shadowOffset, color: viewModel.shadowColor, opacity: viewModel.shadowOpacity, radius: viewModel.shadowRadius)
        cancelButton.addShadow(offset: viewModel.shadowOffset, color: viewModel.shadowColor, opacity: viewModel.shadowOpacity, radius: viewModel.shadowRadius)
        playPauseButton.addShadow(offset: viewModel.shadowOffset, color: viewModel.shadowColor, opacity: viewModel.shadowOpacity, radius: viewModel.shadowRadius)
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
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
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
            timelineSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
            timelineSlider.value = Float(viewModel.audioPlayerPausedTime)
            audioPlayer?.volume = 10
            audioPlayer?.currentTime = viewModel.audioPlayerPausedTime
            sliderEndTime.text = audioPlayer?.duration.minutesAndSeconds
            sliderEndTime.text = audioPlayer?.duration.minutesAndSeconds
        } catch {
            debugPrint("Error Setting up Audio Player \(error)")
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupViewForTheme(for: self.traitCollection.userInterfaceStyle)
    }
    
// MARK: - helper Methods
    private func setViewForRecordingState() {
        UIView.animate(withDuration: kAnimationDuration) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.recordContainerView.alpha = strongSelf.viewModel.recordControlsAlpha
            strongSelf.playbackControlsContainerView.alpha = strongSelf.viewModel.playbackControlsAlpha
        }

        recordButton.setImage(viewModel.recordButtonImage, for: .normal)
        recordTitle.text = viewModel.recordingTitle
        playPauseButton.setImage(viewModel.playPauseIcon, for: .normal)
    }
    
    private func sendAudio() {
        setupAudioPlayer()
        delegate?.sendAudioWithFileUrl(url: viewModel.fileUrl, length: audioPlayer?.duration)
        navigationController?.popViewController(animated: true)
    }
    
    private func updateSlider() {
        timelineSlider.value = Float(audioPlayer?.currentTime ?? 0)
    }
    
    private func setupViewForTheme(for theme: UIUserInterfaceStyle!) {
        recordTitle.textColor = viewModel.getAccentColor(for: theme)
        recordButton.backgroundColor = viewModel.getAccentColor(for: theme)
        sendButton.backgroundColor = viewModel.getAccentColor(for: theme)
        sendButton.setTitleColor(viewModel.getSendTextColor(for: theme), for: .normal)
        playPauseButton.backgroundColor = viewModel.getAccentColor(for: theme)
    }

// MARK: - Button Tap Actions
    @IBAction func onTapRecordButton(_ sender: Any?) {
        viewModel.recordingState.toggle()
        switch viewModel.recordingState {
        case .recording:
            audioRecorder?.record()
            audioRecordingMaxLengthTimer = Timer.scheduledTimer(withTimeInterval: viewModel.maxRecordingTimeLimit, repeats: false) { [weak self] _ in
                if self?.viewModel.recordingState != .recording { return }
                self?.onTapRecordButton(nil)
            }
            
        case .readyToSend:
            audioRecordingMaxLengthTimer?.invalidate()
            audioRecorder?.stop()
            setupAudioPlayer()
        case .readyToRecord:
            break
        }
        setViewForRecordingState()
    }
    
    @IBAction func onTapPlayPauseButton(_ sender: Any) {
        viewModel.isAudioPlaying.toggle()
        if viewModel.isAudioPlaying {
            audioPlayer?.play()
            
            //Timer To Update Progress
            audioProgressUpdateTimer = Timer.scheduledTimer(withTimeInterval: viewModel.timeIntervalToUpdateSlider, repeats: true) { [weak self] _ in
                self?.updateSlider()
            }
        } else {
            viewModel.audioPlayerPausedTime = audioPlayer?.currentTime ?? 0
            audioPlayer?.pause()
             
            audioProgressUpdateTimer?.invalidate()
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
        viewModel.audioPlayerPausedTime = 0
        viewModel.recordingState = .readyToRecord
        audioPlayer?.stop()
        viewModel.isAudioPlaying = false
        setViewForRecordingState()
    }
    
    @IBAction func onTapSendButton(_ sender: Any) {
        sendAudio()
    }
    
    @IBAction func onSliderValueChange(_ sender: Any) {
        audioPlayer?.stop()
        audioPlayer?.currentTime = TimeInterval(timelineSlider.value)
        if viewModel.isAudioPlaying {
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
    }
    
    deinit {
        audioProgressUpdateTimer?.invalidate()
        audioRecordingMaxLengthTimer?.invalidate()
        debugPrint(self.description + "Released From Memory")
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
        viewModel.audioPlayerPausedTime = 0
        timelineSlider.value = 0
        setViewForRecordingState()
    }
}
