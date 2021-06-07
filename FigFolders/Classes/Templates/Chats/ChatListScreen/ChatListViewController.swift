//
//  ChatListViewController.swift
//  FigFolders
//
//  Created by Lourdes on 6/2/21.
//

import UIKit

class ChatListViewController: UIViewController {
    let viewModel = ChatListViewModel()
    
// MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerCells()
        setupDatasourceDelegate()
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
        
    }
    
    private func setupDatasourceDelegate() {
        
    }
    
// MARK: - Button Tap Actions
    @objc private func onTapComposeButton() {
        guard let searchChatViewController = SearchChatViewController.initiateVC() else { return }
        self.present(searchChatViewController, animated: true, completion: nil)
    }
}
