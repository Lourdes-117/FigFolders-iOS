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

class ChatViewController: MessagesViewController {

    let viewModel = ChatViewControllerViewModel()
    
    private var messages = [Message]()
    
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
    }
    
    fileprivate func setupDataSourceDelegate() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messageCellDelegate = self
    }
    
// MARK: - Helper Methods
    fileprivate func listenForMessage() {
        
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
}

// MARK: - Message Cell Delegate
extension ChatViewController: MessageCellDelegate {
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
            videoController.player = AVPlayer(url: viewModel.selectedVideoUrl!)
            videoController.player?.play()
            present(videoController, animated: true)
        default:
            break
        }
    }
}

// MARK:- Input Bar Delegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let messageId = viewModel.generateMessageID(),
              let selfSender = viewModel.selfSender else {
            return
        }
        let message = Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
        if viewModel.isNewConversation {
            //Create Convo in DB
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
            //Append Convo In DB
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
