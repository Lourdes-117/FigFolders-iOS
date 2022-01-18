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
        self.title = viewModel.userNameToPopulate
        registerCells()
        setupDatasourceDelegate()
        getFigFilesInitial()
    }
    
    private func registerCells() {
        let profileNib = UINib(nibName: UserDetailsTableViewCell.kCellId, bundle: Bundle.main)
        tableView.register(profileNib, forCellReuseIdentifier: UserDetailsTableViewCell.kCellId)
        
        let figFilesImageNib = UINib(nibName: FigFilesDisplayImageTableViewCell.kCellId, bundle: Bundle.main)
        tableView.register(figFilesImageNib, forCellReuseIdentifier: FigFilesDisplayImageTableViewCell.kCellId)
        
        let figFilesVideoNib = UINib(nibName: FigFilesDisplayVideoTableViewCell.kCellId, bundle: Bundle.main)
        tableView.register(figFilesVideoNib, forCellReuseIdentifier: FigFilesDisplayVideoTableViewCell.kCellId)
        
        let figFilesPdfNib = UINib(nibName: FigFilesDisplayPdfTableViewCell.kCellId, bundle: Bundle.main)
        tableView.register(figFilesPdfNib, forCellReuseIdentifier: FigFilesDisplayPdfTableViewCell.kCellId)
    }
    
    private func setupDatasourceDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func getFigFilesInitial() {
        viewModel.fetchFigFilesWithPagination { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    private func startPagination() {
        viewModel.fetchFigFilesWithPagination { [weak self] numberOfNewCells in
            guard let strongSelf = self else { return }
            let numberOfFilesBeforeUpdate = strongSelf.viewModel.numberOfFigFiles - numberOfNewCells
            let numberOfFilesAfterUpdate = strongSelf.viewModel.numberOfFigFiles
            if numberOfFilesBeforeUpdate == numberOfFilesAfterUpdate { return }
            let indexPathsToUpdate = strongSelf.viewModel.getIndexPathBetweenNumbers(numberOfItemsBeforeUpdate: numberOfFilesBeforeUpdate, numberOfItemsAfterUpdate: numberOfFilesAfterUpdate)
            strongSelf.tableView.beginUpdates()
            strongSelf.tableView.insertRows(at: indexPathsToUpdate, with: .fade)
            strongSelf.tableView.endUpdates()
        }
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == 1,
              indexPath.row >= (viewModel.numberOfFigFiles - 1) else { return } // This should Not Run For User Details Cell. Only For Fig Files
        startPagination()
    }
}
