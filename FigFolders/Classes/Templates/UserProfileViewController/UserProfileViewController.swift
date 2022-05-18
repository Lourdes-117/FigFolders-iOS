//
//  UserProfileViewController.swift
//  FigFolders
//
//  Created by Lourdes on 9/13/21.
//

import UIKit
import FirebaseAuth

class UserProfileViewController: ViewControllerWithLoading {

    @IBOutlet weak var tableView: UITableView!
    
    var userNameToPopulate: String?
    
    let viewModel = UserProfileViewModel()
    
    weak var figFilesTableViewCellDelegate: FigFilesTableViewCellDelegate?
    
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
        showLoadingIndicator()
        viewModel.fetchFigFilesWithPagination { [weak self] _ in
            self?.tableView.reloadData()
            self?.hideLoadingIndicatorView()
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
        guard let cell = viewModel.getCellForSection(tableView: tableView, indexPath: indexPath) as? FigFilesDisplayTableViewCell,
        let figFile = viewModel.figFiles[indexPath.row] else { return UITableViewCell() }
        cell.likeCommentShareDelegate = self
        cell.figFilesTableViewCellDelegate = self
        cell.setupCell(figFile: figFile)
        return cell
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

extension UserProfileViewController: FigFilesTableViewCellDelegate {
    func followOrUnfollowUser(userNameToFollowOrUnfollow: String) {
        let startIndex = 0
        let endIndex = viewModel.figFiles.count-1
        let arrayToIterate = startIndex...endIndex
        arrayToIterate.forEach { index in
            if viewModel.figFiles[index]?.ownerUsername == userNameToFollowOrUnfollow {
                viewModel.figFiles[index]?.isUserFollowing?.toggle()
            }
        }
        tableView.reloadData()
        self.figFilesTableViewCellDelegate?.followOrUnfollowUser(userNameToFollowOrUnfollow: userNameToFollowOrUnfollow)
    }
    
    func openProfileDetailsPage(userNameToPopulate: String) {
        // Don't have to open profile page from here
    }
    
    func openFigFileLargeView(figFile: FigFileModel?, shouldShowPurchaseScreen: Bool) {
        if shouldShowPurchaseScreen {
            guard let purchaseFigFileViewController = PurchaseFigFileViewController.initiateVC() else { return }
            purchaseFigFileViewController.figFile = figFile
            let navigationController = UINavigationController(rootViewController: purchaseFigFileViewController)
            self.present(navigationController, animated: true, completion: nil)
            return
        }
        // TODO: - Add Types Here
        guard let figFile = figFile else { return }
        switch figFile.fileTypeEnum {
        case .pdf:
            guard let pdfViewerViewController = PDFViewerViewController.initiateVC() else { return }
            pdfViewerViewController.fileUrl = figFile.fileUrlAsUrl
            self.present(pdfViewerViewController, animated: true, completion: nil)
        case .spreadsheet:
            break
        case .image:
            guard let imageViewerViewController = ImageViewerViewController.initiateVC() else { return }
            imageViewerViewController.imageUrl = figFile.fileUrlAsUrl
            self.present(imageViewerViewController, animated: true, completion: nil)
        case .video:
            break
//        case .text:
//            break
//        case .html:
//            break
        case .plainText:
            break
        case .none:
            break
        }
    }
}

// MARK: - Like Comment Share Delegate
extension UserProfileViewController: LikeCommentShareDelegate {
    func onTapLike(figFileLikeModel: FigFileLikeModel?) {
        guard let figfileLikeModel = figFileLikeModel else { return }
        CloudFunctionsManager.shared.likePostByUser(figFileLikeModel: figfileLikeModel)
    }
    
    func onTapComment(figFileModel: FigFileModel?) {
        guard let commentViewController = CommentsViewController.initiateVC() else { return }
        commentViewController.figFileModel = figFileModel
        self.navigationController?.pushViewController(commentViewController, animated: true)
    }
    
    func onTapShare(figFileModel: FigFileModel?) {
        debugPrint("On Tap Share")
    }
}
