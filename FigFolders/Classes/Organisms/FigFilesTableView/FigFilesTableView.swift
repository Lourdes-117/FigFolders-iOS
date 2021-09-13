//
//  FigFilesTableView.swift
//  FigFolders
//
//  Created by Lourdes on 9/11/21.
//

import UIKit

class FigFilesTableView: UIView {
    let nibName = "FigFilesTableView"
    let viewModel = FigFilesTableViewViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var figFilesTableViewCellDelegate: FigFilesTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit(nibName)
    }
    
    func initialSetup() {
        registerCells()
        setupDatasourceDelegate()
        getRandomFilesInitial()
    }
    
    private func getRandomFilesInitial() {
        viewModel.fetchRandomFigFiles { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func registerCells() {
        let figFilesNib = UINib(nibName: FigFilesTableViewCell.kCellId, bundle: Bundle.main)
        tableView.register(figFilesNib, forCellReuseIdentifier: FigFilesTableViewCell.kCellId)
    }
    
    private func setupDatasourceDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func appendRandomFiles() {
        let numberOfFilesBeforeUpdate = viewModel.numberOfFiles
        viewModel.fetchRandomFigFiles { [weak self] in
            guard let strongSelf = self else { return }
            let numberOfFilesAfterUpdate = strongSelf.viewModel.numberOfFiles
            let indexPathsToUpdate = strongSelf.viewModel.getIndexPathBetweenNumbers(numberOfItemsBeforeUpdate: numberOfFilesBeforeUpdate, numberOfItemsAfterUpdate: numberOfFilesAfterUpdate)
            strongSelf.tableView.beginUpdates()
            strongSelf.tableView.insertRows(at: indexPathsToUpdate, with: .fade)
            strongSelf.tableView.endUpdates()
        }
    }
}

// MARK: - TableView Datasource
extension FigFilesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfFiles
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FigFilesTableViewCell.kCellId) as? FigFilesTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(figFile: viewModel.figFiles[indexPath.row], indexPath: indexPath)
        cell.delegate = figFilesTableViewCellDelegate
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - TableView Delegate
extension FigFilesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= (viewModel.numberOfFiles-1) {
            appendRandomFiles()
        }
    }
}
