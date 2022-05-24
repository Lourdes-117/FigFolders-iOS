//
//  SearchViewController.swift
//  FigFolders
//
//  Created by Lourdes Dinesh on 5/24/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    // MARK: - Private Properties
    let viewModel = SearchControllerViewModel()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupDatasourceDelegate()
    }
    
    // MARK: - Initial Setup
    private func initialSetup() {
        self.title = viewModel.pageTitle
        tableView.isHidden = true
    }
    
    private func setupDatasourceDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - TableView Datasource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate {
    
}
