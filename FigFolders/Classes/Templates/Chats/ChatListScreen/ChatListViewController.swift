//
//  ChatListViewController.swift
//  FigFolders
//
//  Created by Lourdes on 6/2/21.
//

import UIKit

class ChatListViewController: ViewControllerWithLoading {
    let viewModel = ChatListViewModel()
    
// MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerCells()
        setupDatasourceDelegate()
        startListeningForConversations()
    }
    
    private func setupView() {
        self.title = viewModel.title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = viewModel.navigationBarColor
        navigationController?.navigationBar.tintColor = viewModel.navigationTitleColor
        setupRightBarButtonItem()
    }
    
    private func setupRightBarButtonItem() {
        let composeBarButton = UIBarButtonItem(image: viewModel.composeMessageImage, style: .plain, target: self, action: #selector(onTapComposeButton))
        navigationItem.rightBarButtonItem = composeBarButton
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: ChatListTableViewCell.kIdentifier, bundle: Bundle.main), forCellReuseIdentifier: ChatListTableViewCell.kIdentifier)
    }
    
    private func setupDatasourceDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func startListeningForConversations() {
        guard let userName = currentUserUsername else { return }
        DatabaseManager.shared.getAllConversationsOfUser(username: userName) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let conversations):
                guard !conversations.isEmpty else { return }
                strongSelf.viewModel.conversations = conversations
                strongSelf.tableView.reloadData()
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
// MARK: - Button Tap Actions
    @objc private func onTapComposeButton() {
        guard let searchChatViewController = SearchChatViewController.initiateVC() else { return }
        searchChatViewController.delegate = self
        self.present(searchChatViewController, animated: true, completion: nil)
    }
    
// MARK: - Helper Methods
    fileprivate func openChatWithUser(name: String, email: String, conversationID: String?) {
        guard let chatViewController = ChatViewController.initiateVC() else { return }
        if conversationID != nil {
            chatViewController.setupConversation(name: name, email: email, conversationID: conversationID)
            chatViewController.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(chatViewController, animated: true)
            return
        }
        
        // Check If Conversation ID Exists With Other User
        DatabaseManager.shared.conversationExistsAtUserNode(with: name) { [weak self] result in
            switch result {
            case .success(let retreivedConversationID):
                chatViewController.setupConversation(name: name, email: email, conversationID: retreivedConversationID)
            case .failure(_):
                chatViewController.setupConversation(name: name, email: email, conversationID: nil)
            }
            chatViewController.navigationItem.largeTitleDisplayMode = .never
            self?.navigationController?.pushViewController(chatViewController, animated: true)
        }
    }
    
}

// MARK: - Search Chat Delegate
extension ChatListViewController: SearchChatSelectionDelegate {
    func didSelectUser(_ emailID: String, _ username: String) {
        if let conversationID = viewModel.getConversationIdForUsername(username: username) {
            // Conversation With User Already Exists
            openChatWithUser(name: username, email: emailID, conversationID: conversationID)
            
        } else {
            // Conversation With User Does Not Exist
            openChatWithUser(name: username, email: emailID, conversationID: nil)
        }
    }
}

// MARK: - Table View Datasource
extension ChatListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfConversations
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = viewModel.conversations[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewCell.kIdentifier) as? ChatListTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(userNameString: conversation.otherUserName, cellType: .chatList, latestMessage: conversation.latestMessage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            tableView.beginUpdates()
            viewModel.conversations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        default:
            debugPrint("Swipe Not Supported")
        }
    }
}

// MARK: - Table View Delegate
extension ChatListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversationID = viewModel.getConversationIdAtIndex(indexPath.row),
        let username = viewModel.getUsernameAtIndex(indexPath.row),
        let emailId = viewModel.getEmailIDAtIndex(indexPath.row) else { return }
        openChatWithUser(name: username, email: emailId, conversationID: conversationID)
    }
}
