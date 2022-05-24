//
//  SearchViewController.swift
//  FigFolders
//
//  Created by Lourdes Dinesh on 5/24/22.
//

import UIKit
import JGProgressHUD

class SearchViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    // MARK: - Private Properties
    let viewModel = SearchControllerViewModel()
    
    private let hud = JGProgressHUD(style: .extraLight)

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        registerCells()
        setupDatasourceDelegate()
    }
    
    // MARK: - Initial Setup
    private func initialSetup() {
        self.title = viewModel.pageTitle
        tableView.isHidden = true
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: ChatListTableViewCell.kIdentifier, bundle: Bundle.main), forCellReuseIdentifier: ChatListTableViewCell.kIdentifier)
    }
    
    private func setupDatasourceDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    
    // MARK: - Helper Methods
    private func searchUserName() {
        if viewModel.queryString.length < 3 {
            tableView.isHidden = true
            self.noResultsLabel.text = viewModel.enterSearchTermString
            return
        }
        tableView.isHidden = false
        hud.show(in: tableView)
        guard !viewModel.shouldInturruptSearch else { return }
        viewModel.searchUserNames(queryUserName: viewModel.queryString) { [weak self] success in
            guard let self = self else { return }
            self.hud.dismiss(animated: true)
            guard success && self.viewModel.searchResultUserNames.count > 0 else {
                self.tableView.isHidden = true
                self.noResultsLabel.text = self.searchBar.text?.isEmpty ?? true ? self.viewModel.enterSearchTermString : self.viewModel.noResultsFoundString
                return
            }
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}

// MARK: - TableView Datasource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchResultUserNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatListTableViewCell.kIdentifier) as? ChatListTableViewCell else { return UITableViewCell() }
        cell.configureCell(userNameString: viewModel.searchResultUserNames.getObjectSafely(indexPath.row), cellType: .search)
        return cell
    }
}

// MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.queryString = (searchBar.text?.lowercased() ?? "").replacingOccurrences(of: " ", with: "")
        view.endEditing(true)
        self.viewModel.shouldInturruptSearch = false
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
            guard let self = self else { return }
            self.searchUserName()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.queryString = (searchText.lowercased()).replacingOccurrences(of: " ", with: "")
        self.viewModel.shouldInturruptSearch = true
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
            guard let self = self else { return }
            self.searchUserName()
        }
    }
}

// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let profileDetailsPage = UserProfileViewController.initiateVC() else { return }
        profileDetailsPage.userNameToPopulate = viewModel.searchResultUserNames.getObjectSafely(indexPath.row)
        navigationController?.pushViewController(profileDetailsPage, animated: true)
    }
}
