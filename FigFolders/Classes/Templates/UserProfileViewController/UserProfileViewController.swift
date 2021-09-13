//
//  UserProfileViewController.swift
//  FigFolders
//
//  Created by Lourdes on 9/13/21.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var userNameToPopulate: String?
    
    let viewModel = UserProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    private func initialSetup() {
        viewModel.userNameToPopulate = userNameToPopulate
        registerCells()
        setupDatasourceDelegate()
    }
    
    private func registerCells() {
        let profileNib = UINib(nibName: UserDetailsTableViewCell.kCellId, bundle: Bundle.main)
        tableView.register(profileNib, forCellReuseIdentifier: UserDetailsTableViewCell.kCellId)
        
        let figFilesNib = UINib(nibName: FigFilesTableViewCell.kCellId, bundle: Bundle.main)
        tableView.register(figFilesNib, forCellReuseIdentifier: FigFilesTableViewCell.kCellId)
    }
    
    private func setupDatasourceDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - TableView Datasource
extension UserProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.getCellForSection(tableView: tableView, indexPath: indexPath)
    }
}

// MARK: - TableView Delegate
extension UserProfileViewController: UITableViewDelegate {
    
}
