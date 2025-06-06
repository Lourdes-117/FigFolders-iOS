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
    @IBOutlet weak var peopleSearchTableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var noResultsBackgroundView: UIView!
    @IBOutlet weak var figFilesTableView: FigFilesTableView!
    
    // MARK: - Private Properties
    let viewModel = SearchControllerViewModel()
    var flowType: searchFlowType = .searchPeople {
        didSet {
            switch flowType {
            case .searchPeople:
                peopleSearchTableView.isHidden = false
                figFilesTableView.isHidden = true
                searchUserName()
            case .searchFiles:
                peopleSearchTableView.isHidden = true
                figFilesTableView.isHidden = false
            }
        }
    }
    
    private let hud = JGProgressHUD(style: .extraLight)

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedController.isHidden = true
        initialSetup()
        registerCells()
        setupDatasourceDelegate()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        noResultsBackgroundView.addGestureRecognizer(tapGesture)
        flowType = .searchPeople
    }
    
    // MARK: - Initial Setup
    private func initialSetup() {
        self.title = viewModel.pageTitle
        peopleSearchTableView.isHidden = true
    }
    
    private func registerCells() {
        peopleSearchTableView.register(UINib(nibName: ChatListTableViewCell.kIdentifier, bundle: Bundle.main), forCellReuseIdentifier: ChatListTableViewCell.kIdentifier)
    }
    
    private func setupDatasourceDelegate() {
        peopleSearchTableView.dataSource = self
        peopleSearchTableView.delegate = self
        searchBar.delegate = self
    }
    
    
    // MARK: - Helper Methods
    private func searchUserName() {
        viewModel.searchResultUserNames.removeAll()
        if viewModel.queryString.length < 3 {
            peopleSearchTableView.isHidden = true
            self.noResultsLabel.text = viewModel.enterSearchTermString
            return
        }
        peopleSearchTableView.reloadData()
        peopleSearchTableView.isHidden = false
        hud.show(in: peopleSearchTableView)
        guard !viewModel.shouldInturruptSearch else { return }
        viewModel.searchUserNames(queryUserName: viewModel.queryString) { [weak self] success in
            guard let self = self else { return }
            self.hud.dismiss(animated: true)
            guard success && self.viewModel.searchResultUserNames.count > 0 else {
                self.peopleSearchTableView.isHidden = true
                self.noResultsLabel.text = self.searchBar.text?.isEmpty ?? true ? self.viewModel.enterSearchTermString : self.viewModel.noResultsFoundString
                return
            }
            self.peopleSearchTableView.isHidden = false
            self.peopleSearchTableView.reloadData()
        }
    }
    
    // MARK: - Actions
    @IBAction func segmentValueChanged(_ sender: Any) {
        guard let selectedSearchType = searchFlowType(rawValue: segmentedController.selectedSegmentIndex) else { return }
        flowType = selectedSearchType
        view.endEditing(true)
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
        view.endEditing(true)
        profileDetailsPage.userNameToPopulate = viewModel.searchResultUserNames.getObjectSafely(indexPath.row)
        navigationController?.pushViewController(profileDetailsPage, animated: true)
    }
}
