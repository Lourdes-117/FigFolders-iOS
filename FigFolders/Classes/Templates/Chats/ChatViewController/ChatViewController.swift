//
//  ChatViewController.swift
//  FigFolders
//
//  Created by Lourdes on 6/15/21.
//

import MessageKit
import InputBarAccessoryView
import UIKit
import AVKit
import MapKit
import NVActivityIndicatorView
import CoreLocation

class ChatViewController: MessagesViewController {

    let viewModel = ChatViewControllerViewModel()
    
    private var messages = [Message]()
    
    private var audioPlayer: AVAudioPlayer?
    private var audioProgressUpdateTimer: Timer?
    private var activityBackgroundView: UIView?
    private var activityView: NVActivityIndicatorView?
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    func setupConversation(name: String, email: String, conversationID: String?) {
        title = name
        viewModel.receiverName = name
        viewModel.receiverEmail = email
        viewModel.conversationID = conversationID
        listenForMessage()
    }
    
    fileprivate func initialSetup() {
        setupDataSourceDelegate()
        setupInputBar()
    }
    
    fileprivate func setupDataSourceDelegate() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messageCellDelegate = self
    }
    
    // MARK: - Adding Media
    func setupInputBar() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(viewModel.inputBarButtonIcon, for: .normal)
        button.onTouchUpInside { [weak self] _ in
            self?.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    
    private func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: viewModel.attachMediaTitle, message: viewModel.attachMediaMessage, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: viewModel.photo, style: .default, handler: { [weak self] _ in
            self?.presentPhotoInputActionSheet()
        }))
        actionSheet.addAction(UIAlertAction(title: viewModel.video, style: .default, handler: { [weak self] _ in
            self?.presentVideoInputActionSheet()
        }))
        actionSheet.addAction(UIAlertAction(title: viewModel.audio, style: .default, handler: { [weak self] _ in
            self?.presentVoiceRecordingViewController()
        }))
        actionSheet.addAction(UIAlertAction(title: viewModel.location, style: .default, handler: { [weak self] _ in
            self?.presentLocationInputViewController()
        }))
        actionSheet.addAction(UIAlertAction(title: viewModel.cancel, style: .cancel, handler: { _ in
            
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    // Send Photo
    private func presentPhotoInputActionSheet() {
        let actionSheet = UIAlertController(title: viewModel.attachPhotoTitle, message: viewModel.attachPhotoMessage, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: viewModel.camera, style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = false
            self?.present(picker, animated: false, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: viewModel.photoLibrary, style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = false
            self?.present(picker, animated: false, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: viewModel.cancel, style: .cancel, handler: { _ in
            
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    // Send Video
    private func presentVideoInputActionSheet() {
        let actionSheet = UIAlertController(title: viewModel.attachVideoTitle, message: viewModel.attachVideoMessage, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: viewModel.camera, style: .default, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            picker.mediaTypes = [strongSelf.viewModel.mediaTypeForVideo]
            picker.videoQuality = strongSelf.viewModel.videoQualityType
            picker.videoMaximumDuration = strongSelf.viewModel.videoMaxLength
            self?.present(picker, animated: false, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: viewModel.photoLibrary, style: .default, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            picker.mediaTypes = [strongSelf.viewModel.mediaTypeForVideo]
            picker.videoQuality = strongSelf.viewModel.videoQualityType
            picker.videoMaximumDuration = strongSelf.viewModel.videoMaxLength
            self?.present(picker, animated: false, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: viewModel.cancel, style: .cancel, handler: { _ in
            
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    // Send Location
    private func presentLocationInputViewController() {
        guard let locationPickerViewController = LocationPickerViewController.initiateVC() else { return }
        locationPickerViewController.delegate = self
        navigationController?.pushViewController(locationPickerViewController, animated: true)
    }
    
    // Send Location
    private func presentVoiceRecordingViewController() {
        guard let voiceRecordingViewController = VoiceRecordingViewController.initiateVC() else { return }
        voiceRecordingViewController.delegate = self
        navigationController?.pushViewController(voiceRecordingViewController, animated: true)
    }
    
    // MARK: - Helper Methods
    private func listenForMessage() {
        guard let conversationID = viewModel.conversationID else { return }
        showLoadingIndicator()
        DatabaseManager.shared.getAllMessagesForConversation(with: conversationID) { [weak self] result in
            self?.hideLoadingIndicatorView()
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    if self?.messages.isEmpty ?? true {
                        self?.messages = messages
                        self?.messagesCollectionView.reloadData()
                        self?.messagesCollectionView.scrollToLastItem()
                    } else {
                        self?.messages = messages
                        self?.messagesCollectionView.reloadDataAndKeepOffset()
                    }
                }
            case .failure(let error):
                debugPrint("Failed To Fetch messages \(error)")
            }
        }
    }
    
    private func setupAudioPlayer(cell: AudioMessageCell, messageID: String) {
        cell.addDownloadingIndicator()
        StorageManager.shared.downloadAudioWithName(messageID) { [weak self] audioFileData, error in
            DispatchQueue.main.async {
                cell.removeDownloadingIndicator()
                
                guard error == nil,
                      let audioFileData = audioFileData else {
                    debugPrint("Error Downloading Audio \(String(describing: error))")
                    return
                }
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                    self?.audioPlayer = try AVAudioPlayer(data: audioFileData)
                    self?.audioPlayer?.prepareToPlay()
                    self?.audioPlayer?.delegate = self
                    self?.audioPlayer?.volume = 10
                    self?.audioPlayer?.play()
                    self?.viewModel.audioDurationPlayed = 1
                    self?.viewModel.selectedAudioDuration = self?.audioPlayer?.duration
                    self?.audioProgressUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                        self?.viewModel.audioDurationPlayed = (self?.viewModel.audioDurationPlayed ?? 0) + 1
                        self?.viewModel.selectedAudioCell?.progressView.setProgress(Float(self?.viewModel.audioProgress ?? 0), animated: true)
                    }
                } catch {
                    debugPrint("Error Setting up Audio Player \(error)")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ImageViewerViewController {
            viewController.imageUrl = viewModel.selectedImageUrl
        }
    }
    
    deinit {
        audioProgressUpdateTimer?.invalidate()
        debugPrint(self.description + "Released From Memory")
    }
}

// MARK: - Message Datasource
extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        guard let selfSender = viewModel.selfSender else {
            return Sender(senderId: "", displayName: "", photoUrl: "")
        }
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else { return }
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else { return }
            imageView.sd_setImage(with: imageUrl, completed: nil)
        default:
            break
        }
    }
}

// MARK: - Message Delegate
extension ChatViewController: MessagesLayoutDelegate {
    
}

// MARK: - Message Display Delegate
extension ChatViewController: MessagesDisplayDelegate {
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return isFromCurrentSender(message: message) ? .bubbleTail(.bottomRight, .curved) : .bubbleTail(.bottomLeft, .pointedEdge)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.initials = message.sender.displayName[viewModel.avatarStringStartingIndexForAvatar ..< viewModel.avatarStringEndingIndexForAvatar].capitalized
    }
    
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
        return { view in
            view.layer.transform = CATransform3DMakeScale(2, 2, 2)
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                view.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
    }
    
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        return LocationMessageSnapshotOptions(showsBuildings: true, showsPointsOfInterest: true, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    }
}

// MARK: - Message Cell Delegate
extension ChatViewController: MessageCellDelegate {
    func didTapMessage(in cell: MessageCollectionViewCell) {
        dismissKeyboard()
        guard let section = messagesCollectionView.indexPath(for: cell)?.section else { return }
        let message = messages[section]
        switch message.kind {
        case .location(let location):
            openAppleMapsWithLocation(location)
        default:
            break
        }
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        dismissKeyboard()
        guard let section = messagesCollectionView.indexPath(for: cell)?.section else { return }
        let message = messages[section]
        switch message.kind {
        case .photo(let media):
            viewModel.selectedImageUrl = media.url
            performSegue(withIdentifier: viewModel.imageViewerSegueIdentifier, sender: nil)
        case .video(let media):
            viewModel.selectedVideoUrl = media.url
            let videoController = AVPlayerViewController()
            guard let videoUrl = viewModel.selectedVideoUrl else { return }
            videoController.player = AVPlayer(url: videoUrl)
            videoController.player?.play()
            present(videoController, animated: true)
        default:
            break
        }
    }
    
    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
        cell.durationLabel.isHidden = true
    }
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        if audioPlayer?.isPlaying ?? false {
            audioProgressUpdateTimer?.invalidate()
            if viewModel.selectedAudioCell == cell {
                audioPlayer?.stop()
                cell.progressView.setProgress(0, animated: false)
                cell.playButton.isSelected = false
                return
            } else {
                audioPlayer?.stop()
                viewModel.selectedAudioCell?.playButton.isSelected = false
                viewModel.selectedAudioCell?.progressView.setProgress(0, animated: false)
            }
        }
        viewModel.selectedAudioCell = cell
        guard let index = messagesCollectionView.indexPath(for: cell)?.section else { return }
        setupAudioPlayer(cell: cell, messageID: messages[index].messageId)
        cell.playButton.isSelected = true
    }
}

// MARK: - Input Bar Delegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let messageId = viewModel.generateMessageID(),
              let selfSender = viewModel.selfSender else {
            return
        }
        let message = Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
        if viewModel.isNewConversation {
            // Create Convo in DB
            self.messageInputBar.inputTextView.text = ""
            DatabaseManager.shared.createNewConversation(with: viewModel.receiverEmail, messageToSend : message, otherUserName: viewModel.receiverName) { [weak self] success in
                if success {
                    self?.messagesCollectionView.reloadData()
                    self?.viewModel.conversationID = messageId
                    self?.listenForMessage()
                    debugPrint("Message Sent")
                } else {
                    debugPrint("Failed To Send")
                }
            }
        } else {
            // Append Convo In DB
            guard let conversationID = viewModel.conversationID else {
                return
            }
            self.messageInputBar.inputTextView.text = ""
            DatabaseManager.shared.sendMessage(conversationID: conversationID, senderEmail: viewModel.senderEmail ?? "", senderName: viewModel.senderName, message: message, receiverEmailId: viewModel.receiverEmail, receiverName: viewModel.receiverName, existingConversationID: viewModel.conversationID) { success in
                if success {
                    debugPrint("Message Sent")
                } else {
                    debugPrint("Failed To Send")
                }
            }
        }
    }
}

// MARK: - Image Picker Delegate
extension ChatViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        // Upload Image
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let imageData = image.jpeg(.low) {
            guard let messageID = viewModel.generateMessageID(),
                  let selfSender = viewModel.selfSender,
                  let senderEmail = viewModel.senderEmail,
                  let lowResImageData = image.jpeg(.lowest),
                  let lowResImage = UIImage(data: lowResImageData) else { return }
                  let conversationID = viewModel.conversationID ?? messageID
            
            // Upload Image
            let fileName = messageID
            StorageManager.shared.uploadMessagePhoto(with: imageData, fileName: fileName) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let urlString):
                    let url = URL(string: urlString)
                    let media = Media(url: url, image: image, placeholderImage: lowResImage, size: .zero)
                    let message = Message(sender: selfSender, messageId: messageID, sentDate: Date(), kind: .photo(media))
                    // Sending Message
                    if strongSelf.viewModel.isNewConversation {
                        DatabaseManager.shared.createNewConversation(with: strongSelf.viewModel.receiverEmail, messageToSend : message, otherUserName: strongSelf.viewModel.receiverName) { [weak self] success in
                            if success {
                                self?.messagesCollectionView.reloadData()
                                self?.viewModel.conversationID = conversationID
                                self?.listenForMessage()
                                debugPrint("Message Sent")
                            } else {
                                debugPrint("Failed To Send")
                            }
                        }
                    } else {
                        DatabaseManager.shared.sendMessage(conversationID: conversationID, senderEmail: senderEmail, senderName: strongSelf.viewModel.senderName, message: message, receiverEmailId: strongSelf.viewModel.receiverEmail, receiverName: strongSelf.viewModel.receiverName, existingConversationID: strongSelf.viewModel.conversationID) { success in
                            if success {
                                debugPrint("Image Message Sent")
                            } else {
                                debugPrint("Image Message Sending Failure")
                            }
                        }
                    }
                case .failure(let error):
                    debugPrint("Message Photo upload Error \(error)")
                }
            }
        } else if let videoUrl = info[.mediaURL] as? URL,
                  let messageID = viewModel.generateMessageID(),
                  let selfSender = viewModel.selfSender,
                  let senderEmail = viewModel.senderEmail {
            let conversationID = viewModel.conversationID ?? messageID
            let fileName = "\(messageID)\(StringConstants.shared.storage.videoExtension)"
            StorageManager.shared.uploadMessageVideo(from: videoUrl, fileName: fileName) { [weak self ] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let urlString):
                    debugPrint("Uploaded Video")
                    let url = URL(string: urlString)
                    let media = Media(url: url, image: nil, placeholderImage: UIImage(), size: .zero)
                    let message = Message(sender: selfSender, messageId: messageID, sentDate: Date(), kind: .video(media))
                    //Sending Message
                    if strongSelf.viewModel.isNewConversation {
                        // Create Convo in DB
                        DatabaseManager.shared.createNewConversation(with: strongSelf.viewModel.receiverEmail, messageToSend : message, otherUserName: strongSelf.viewModel.receiverName) { [weak self] success in
                            if success {
                                self?.messagesCollectionView.reloadData()
                                self?.viewModel.conversationID = conversationID
                                self?.listenForMessage()
                                debugPrint("Message Sent")
                            } else {
                                debugPrint("Failed To Send")
                            }
                        }
                    } else {
                        DatabaseManager.shared.sendMessage(conversationID: conversationID, senderEmail: senderEmail, senderName: strongSelf.viewModel.senderName, message: message, receiverEmailId: strongSelf.viewModel.receiverEmail, receiverName: strongSelf.viewModel.receiverName, existingConversationID: strongSelf.viewModel.conversationID) { success in
                            if success {
                                debugPrint("Video Message Sent")
                            } else {
                                debugPrint("Video Message Sending Failure")
                            }
                        }
                }
                case .failure(let error):
                    debugPrint("Video Upload Failed \(error)")
                }
            }
        }
    }
}

// MARK: - Loading Indicator
extension ChatViewController {
    func showLoadingIndicator(with type: NVActivityIndicatorType = .orbit, color: UIColor = .blue) {
        activityBackgroundView = UIView(frame: view.frame)
        activityBackgroundView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        activityView = NVActivityIndicatorView(frame: CGRect(x: (view.frame.width/2)-50,
                                                             y: (view.frame.height/2)-50,
                                                             width: 100,
                                                             height: 100),
                                               type: type,
                                               color: color,
                                               padding: 0)
        guard let activityBackgroundView = activityBackgroundView,
              let activityView = activityView else { return }
        // Blur
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityBackgroundView.addSubview(blurEffectView)
        activityBackgroundView.addSubview(activityView)
        activityView.startAnimating()
        view.addSubview(activityBackgroundView)
    }
    
    func hideLoadingIndicatorView() {
        guard let activityView = activityView,
              let activityBackgroundView = activityBackgroundView else { return }
        activityView.stopAnimating()
        activityBackgroundView.removeFromSuperview()
    }
}

extension ChatViewController: UINavigationControllerDelegate {
    
}

// MARK: - Location Picker Delegate
extension ChatViewController: LocationPickerDelegate {
    func selectedLocationToSend(_ location: CLLocationCoordinate2D) {
        debugPrint("Selected Location To Send: \(location.latitude), \(location.longitude)")
        // Send Location
        guard let messageID = viewModel.generateMessageID(),
              let selfSender = viewModel.selfSender,
              let senderEmail = viewModel.senderEmail  else { return }
        let conversationID = viewModel.conversationID ?? messageID
        
        let media = Location(location: CLLocation(latitude: location.latitude, longitude: location.longitude), size: .zero)
        let message = Message(sender: selfSender, messageId: messageID, sentDate: Date(), kind: .location(media))
        // Sending Message
        if viewModel.isNewConversation {
            // Create Convo in DB
            DatabaseManager.shared.createNewConversation(with: viewModel.receiverEmail, messageToSend : message, otherUserName: viewModel.receiverName) { [weak self] success in
                if success {
                    self?.messagesCollectionView.reloadData()
                    self?.viewModel.conversationID = conversationID
                    self?.listenForMessage()
                    debugPrint("Message Sent")
                } else {
                    debugPrint("Failed To Send")
                }
            }
        } else {
            DatabaseManager.shared.sendMessage(conversationID: conversationID, senderEmail: senderEmail, senderName: viewModel.senderName, message: message, receiverEmailId: viewModel.receiverEmail, receiverName: viewModel.receiverName, existingConversationID: viewModel.conversationID) { success in
                if success {
                    debugPrint("Location Message Sent")
                } else {
                    debugPrint("Location Message Sending Failure")
                }
            }
        }
    }
}


// MARK: - Voice Recording Delegate
extension ChatViewController: VoiceRecordingDelegate {
    func sendAudioWithFileUrl(url: URL?, length: TimeInterval?) {
        guard let messageID = viewModel.generateMessageID(),
              let selfSender = viewModel.selfSender,
              let senderEmail = viewModel.senderEmail,
              let audioLength = length,
              let fileUrl = url else { return }
        let conversationID = viewModel.conversationID ?? messageID
        
        let receiverEmail = viewModel.receiverEmail
        let senderName = viewModel.senderName
        let receiverName = viewModel.receiverName
        
        StorageManager.shared.uploadMessageAudio(from: fileUrl, fileName: messageID) { [weak self] result in
            switch result {
            case .success(let url):
                guard let cloudUrl = URL(string: url),
                let strongSelf = self else { return }
                let audioItem = Audio(duration: Float(audioLength), size: .zero, url: cloudUrl)
                let message = Message(sender: selfSender, messageId: messageID, sentDate: Date(), kind: .audio(audioItem))
                if strongSelf.viewModel.isNewConversation {
                    // Create Convo in DB
                    DatabaseManager.shared.createNewConversation(with: strongSelf.viewModel.receiverEmail, messageToSend : message, otherUserName: strongSelf.viewModel.receiverName) { [weak self] success in
                        if success {
                            self?.messagesCollectionView.reloadData()
                            self?.viewModel.conversationID = conversationID
                            self?.listenForMessage()
                            debugPrint("Message Sent")
                        } else {
                            debugPrint("Failed To Send")
                        }
                    }
                } else {
                    DatabaseManager.shared.sendMessage(conversationID: conversationID, senderEmail: senderEmail, senderName: senderName, message: message, receiverEmailId: receiverEmail, receiverName: receiverName, existingConversationID: conversationID) { success in
                        debugPrint(success)
                    }
                }
            case .failure(let error):
                debugPrint("Error Uploading AudioFile \(error)")
            }
        }
    }
}

// MARK: AVAudioPlayer Delegate
extension ChatViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        debugPrint("Audio Finished Playing")
        viewModel.selectedAudioCell?.playButton.isSelected = false
        viewModel.selectedAudioCell?.progressView.setProgress(1, animated: true)
        audioProgressUpdateTimer?.invalidate()
        viewModel.selectedAudioCell?.progressView.setProgress(0, animated: false)
    }
}
