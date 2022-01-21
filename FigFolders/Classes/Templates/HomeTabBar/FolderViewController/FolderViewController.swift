//
//  FolderViewController.swift
//  FigFolders
//
//  Created by Lourdes on 1/21/22.
//

import UIKit

class FolderViewController: UIViewController {
// MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = FolderViewModel()
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    private func initialSetup() {
        registerCells()
        seupDatasourceDelegate()
        self.title = viewModel.pageTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func registerCells() {
        let folderViewNib = UINib(nibName: FolderViewCollectionViewCell.kCellId, bundle: Bundle.main)
        collectionView.register(folderViewNib, forCellWithReuseIdentifier: FolderViewCollectionViewCell.kCellId)
    }
    
    private func seupDatasourceDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - CollectionView Datasource
extension FolderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderViewCollectionViewCell.kCellId, for: indexPath) as? FolderViewCollectionViewCell else { return UICollectionViewCell() }
        cell.setupCell(cellType: viewModel.getCellTypeAtIndex(index: indexPath.row))
        return cell
    }
}

// MARK: - CollectionView Delegate
extension FolderViewController: UICollectionViewDelegate {

}

extension FolderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSideSize = view.frame.width * 0.45
        return CGSize(width: cellSideSize, height: cellSideSize + 50)
    }
}
