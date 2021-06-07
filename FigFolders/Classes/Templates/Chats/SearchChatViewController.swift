//
//  SearchChatViewController.swift
//  FigFolders
//
//  Created by Lourdes on 6/5/21.
//

import UIKit

class SearchChatViewController: ViewControllerWithLoading {
    
    private var users = [[String: String]]()
    private var searchResults = [[String: String]]()
    private var hasFetched = false
    
    let viewModel = SearchChatViewModel()
    
// MARK: - Outlets
    @IBOutlet weak var pullDownTopBarView: PullDownTopBarView!
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupDataSourceDelegate()
    }
    
    private func initialSetup() {
        pullDownTopBarView.delegate = self
        pullDownTopBarView.titleString = viewModel.title
        
    }
    
    fileprivate func setupDataSourceDelegate() {
        searchView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
// MARK: - Helper Methods
    func searchUsers(query: String) {
        if hasFetched {
            filterUsers(with: query)
        } else {
            DatabaseManager.shared.getAllUsers { [weak self] results in
                switch results {
                case .success(let users):
                    self?.users = users
                case .failure(let error):
                    debugPrint(error)
                }
                self?.hasFetched = true
                self?.filterUsers(with: query)
            }
        }
    }
    
    func filterUsers(with term: String) {
        guard hasFetched else { return }
            
        let results: [[String: String]] = self.users.filter { user in
            guard let usernameIteration = user.values.first?.lowercased(),
                  usernameIteration != currentUserUsername else { return false }
            return usernameIteration.hasPrefix(term)
        }
        self.searchResults = results
        
        self.tableView.reloadData()
    }
}

// MARK: - Pull Down Top Bar Delegate
extension SearchChatViewController: PullDownTopBarViewDelegate {
    func onTapDismissButton() {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Search Bar Delegate
extension SearchChatViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty, !text.replacingOccurrences(of: " ", with: "").isEmpty else { return }
        searchBar.resignFirstResponder()
        searchResults.removeAll()
        hasFetched = false
        searchUsers(query: text.lowercased())
    }
}


// MARK: - TableView Datasource
extension SearchChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - TableView Delegate
extension SearchChatViewController: UITableViewDelegate {
    
}
