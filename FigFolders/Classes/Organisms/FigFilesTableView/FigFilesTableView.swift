//
//  FigFilesTableView.swift
//  FigFolders
//
//  Created by Lourdes on 9/11/21.
//

import UIKit

protocol FigFileTableViewDelegate: AnyObject {
    func initialNetworkCallStarted()
    func initialNetworkCallFinishedWithNumberOfItems(newItems: Int)
    func paginationCallStarted()
    func paginationCallEnded(newItems: Int)
}

class FigFilesTableView: UIView {
    let nibName = "FigFilesTableView"
    let viewModel = FigFilesTableViewViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var figFilesTableViewCellDelegate: FigFilesTableViewCellDelegate?
    weak var likeCommentShareDelegate: LikeCommentShareDelegate?
    weak var figFileTableViewDelegate: FigFileTableViewDelegate?
    
    var documentTypeToPopulate: DocumentPickerDocumentType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit(nibName)
    }
    
    func initialSetup(pageBehaviour: FigFilesTableViewBehaviour) {
        viewModel.figFilesTableViewBehaviour = pageBehaviour
        viewModel.documentTypeToPopulate = documentTypeToPopulate
        registerCells()
        setupDatasourceDelegate()
        getRandomFilesInitial()
    }
    
    private func getRandomFilesInitial() {
        figFileTableViewDelegate?.initialNetworkCallStarted()
        viewModel.fetchRandomFigFiles { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.figFileTableViewDelegate?.initialNetworkCallFinishedWithNumberOfItems(newItems: self.viewModel.numberOfFiles)
        }
    }
    
    private func registerCells() {
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
    
    private func startPagination() {
        figFileTableViewDelegate?.paginationCallStarted()
        viewModel.fetchRandomFigFiles { [weak self] numberOfNewCells in
            guard let strongSelf = self else { return }
            let numberOfFilesBeforeUpdate = strongSelf.viewModel.numberOfFiles -  numberOfNewCells
            let numberOfFilesAfterUpdate = strongSelf.viewModel.numberOfFiles
            guard numberOfFilesBeforeUpdate != numberOfFilesAfterUpdate else { return } // Pagination Returned No Values
            let indexPathsToUpdate = strongSelf.viewModel.getIndexPathBetweenNumbers(numberOfItemsBeforeUpdate: numberOfFilesBeforeUpdate, numberOfItemsAfterUpdate: numberOfFilesAfterUpdate)
            strongSelf.tableView.beginUpdates()
            strongSelf.tableView.insertRows(at: indexPathsToUpdate, with: .fade)
            strongSelf.tableView.endUpdates()
            strongSelf.figFileTableViewDelegate?.paginationCallEnded(newItems: numberOfNewCells)
        }
    }
}

// MARK: - TableView Datasource
extension FigFilesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfFiles
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = viewModel.figFiles[indexPath.row].figFileDisplayCellId
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? FigFilesDisplayTableViewCell else { return UITableViewCell() }
        cell.figFilesTableViewCellDelegate = figFilesTableViewCellDelegate
        cell.likeCommentShareDelegate = likeCommentShareDelegate
        cell.setupCell(figFile: viewModel.figFiles[indexPath.row])
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
        if indexPath.row >= (viewModel.numberOfFiles-3) {
            startPagination()
        }
    }
}
