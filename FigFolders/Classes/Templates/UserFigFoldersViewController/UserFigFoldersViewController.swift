//
//  UserFigFoldersViewController.swift
//  FigFolders
//
//  Created by Lourdes on 1/23/22.
//

import UIKit
import AVKit

class UserFigFoldersViewController: ViewControllerWithLoading {
// MARK: - Outlets
    @IBOutlet weak var tableView: FigFilesTableView!
    
    var documentTypeToPopulate: DocumentPickerDocumentType?
    private let viewModel = UserFigFoldersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        self.title = documentTypeToPopulate?.rawValue.capitalized
        tableView.figFileTableViewDelegate = self
        tableView.documentTypeToPopulate = documentTypeToPopulate
        setupDatasourceDelegate()
        tableView.initialSetup(pageBehaviour: .figFilesPage)
    }
    
    private func setupDatasourceDelegate() {
        tableView.LikeCommentReportDelegate = self
        tableView.figFilesTableViewCellDelegate = self
    }
}

// MARK: - Like Comment Share Delegate
extension UserFigFoldersViewController: LikeCommentReportDelegate {
    func onTapLike(figFileLikeModel: FigFileLikeModel?) {
        guard let figfileLikeModel = figFileLikeModel else { return }
        CloudFunctionsManager.shared.likePostByUser(figFileLikeModel: figfileLikeModel)
    }
    
    func onTapComment(figFileModel: FigFileModel?) {
        guard let commentViewController = CommentsViewController.initiateVC() else { return }
        commentViewController.figFileModel = figFileModel
        self.navigationController?.pushViewController(commentViewController, animated: true)
    }
    
    func onTapReport(figFileModel: FigFileModel?) {
        debugPrint("On Tap Report")
    }
}

// MARK: - Fig Files TableView Delegate
extension UserFigFoldersViewController: FigFilesTableViewCellDelegate {
    func didTapFullScreenOnVideo(avPlayer: AVPlayer) {
        let videoPlayerController = HomeScreenVideoPlayer()
        videoPlayerController.player = avPlayer
        self.present(videoPlayerController, animated: true)
    }
    
    func followOrUnfollowUser(userNameToFollowOrUnfollow: String) {
        //
    }
    
    func onTapProfileIcon(userNameToPopulate: String) {
        guard let profileDetailsPage = UserProfileViewController.initiateVC() else { return }
        profileDetailsPage.userNameToPopulate = userNameToPopulate
        navigationController?.pushViewController(profileDetailsPage, animated: true)
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

// MARK: - FigFile TableView Delegate
extension UserFigFoldersViewController: FigFileTableViewDelegate {
    func initialNetworkCallStarted() {
        showLoadingIndicator()
    }
    
    func initialNetworkCallFinishedWithNumberOfItems(newItems: Int) {
        hideLoadingIndicatorView()
        tableView.isHidden = newItems == 0
    }
    
    func paginationCallStarted() {
        // Not needed
    }
    
    func paginationCallEnded(newItems: Int) {
        // Not needed
    }
}
