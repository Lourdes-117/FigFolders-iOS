//
//  HomeViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/16/21.
//

import UIKit
import FirebaseAuth
import AVKit

class HomeViewController: ViewControllerWithLoading {
// MARK: - Outlets
    @IBOutlet weak var hamburgerMenuView: HamburgerMenuView!
    @IBOutlet weak var hamburgerMenuLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var hamburgerMenuOverflowView: UIView!
    @IBOutlet weak var figFilesTableView: FigFilesTableView!
    
    let viewModel = HomeViewControllerViewModel()
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // To reflect if any change made. Especially in profile page
        figFilesTableView.tableView.reloadData()
    }
    
    private func initialSetup() {
        setUserDefaults()
        setupView()
        setupGestures()
        setupDelegate()
        figFilesTableView.initialSetup(pageBehaviour: .homePage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupView() {
        navigationController?.navigationBar.backgroundColor = viewModel.navigationBarColor
        navigationController?.navigationBar.tintColor = viewModel.navigationTitleColor
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: viewModel.leftBarButtonImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(onTapHamburgerMenuIcon))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: viewModel.rightBarButtonImage,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(onTapChatIcon))
        self.title = viewModel.pageTitle
        UINavigationBar.appearance().barTintColor = viewModel.navigationBarColor
        navigationController?.navigationBar.tintColor = viewModel.navigationIconsColor
        hamburgerMenuLeftConstraint.constant = viewModel.hamburgerMenuLeftConstraint
        hamburgerMenuOverflowView.isHidden = true
    }
    
    private func setupGestures() {
        let dismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapOverflowView))
        hamburgerMenuOverflowView.addGestureRecognizer(dismissTapGesture)
        let dismissPanGesture = UIPanGestureRecognizer(target: self, action: #selector(onTapOverflowView))
        hamburgerMenuOverflowView.addGestureRecognizer(dismissPanGesture)
    }
    
    private func setUserDefaults() {
        let unsafeEmail = (UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.emailID) as? String) ?? UserDetailsModel.getSafeEmail(email: FirebaseAuth.Auth.auth().currentUser?.email ?? "")
        let emailID = UserDetailsModel.getSafeEmail(email: unsafeEmail)
        if let userName = (UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.userName) as? String) {
            DatabaseManager.shared.getUserDetailsForUsername(username: userName) { [weak self] userDetails in
                guard let userDetails = userDetails else {
                    self?.hideLoadingIndicatorView()
                    return
                }
                UserDefaults.standard.setValue(userDetails.firstName, forKey: StringConstants.shared.userDefaults.firstName)
                UserDefaults.standard.setValue(userDetails.lastName, forKey: StringConstants.shared.userDefaults.lastName)
                UserDefaults.standard.setValue(userDetails.safeEmail, forKey: StringConstants.shared.userDefaults.emailID)
                UserDefaults.standard.setValue(userDetails.phoneNumber, forKey: StringConstants.shared.userDefaults.phoneNumber)
                UserDefaults.standard.setValue(userDetails.dateOfBirth, forKey: StringConstants.shared.userDefaults.dateOfBirth)
                self?.hamburgerMenuView.refreshView()
            }
        } else {
            DatabaseManager.shared.getUsernameForEmail(emailID: emailID) { [weak self] userName in
                guard let userName = userName else {
                    self?.hideLoadingIndicatorView()
                    return
                }
                DatabaseManager.shared.getUserDetailsForUsername(username: userName) { userDetails in
                    guard let userDetails = userDetails else {
                        self?.hideLoadingIndicatorView()
                        return
                    }
                    UserDefaults.standard.setValue(userDetails.username, forKey: StringConstants.shared.userDefaults.userName)
                    UserDefaults.standard.setValue(userDetails.firstName, forKey: StringConstants.shared.userDefaults.firstName)
                    UserDefaults.standard.setValue(userDetails.lastName, forKey: StringConstants.shared.userDefaults.lastName)
                    UserDefaults.standard.setValue(userDetails.safeEmail, forKey: StringConstants.shared.userDefaults.emailID)
                    UserDefaults.standard.setValue(userDetails.phoneNumber, forKey: StringConstants.shared.userDefaults.phoneNumber)
                    UserDefaults.standard.setValue(userDetails.dateOfBirth, forKey: StringConstants.shared.userDefaults.dateOfBirth)
                    self?.hamburgerMenuView.refreshView()
                    self?.hideLoadingIndicatorView()
                }
            }
        }
    }
    
    private func setupDelegate() {
        hamburgerMenuView.delegate = self
        figFilesTableView.figFileTableViewDelegate = self
        figFilesTableView.figFilesTableViewCellDelegate = self
        figFilesTableView.likeCommentShareDelegate = self
    }
    
// MARK: - Button Actions
    @objc private func onTapOverflowView() {
        viewModel.isHamburgerMenuExpanded = false
        expandOrCollapseHamburgerMenu()
    }
    
    @objc private func onTapHamburgerMenuIcon() {
        viewModel.isHamburgerMenuExpanded.toggle()
        expandOrCollapseHamburgerMenu()
    }
    
    @objc func onTapChatIcon() {
        guard let vc = ChatListViewController.initiateVC() else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
// MARK: - Helper Methods
    private func expandOrCollapseHamburgerMenu(completion: (() -> Void)? = nil) {
        hamburgerMenuView.expandOrCollapseMenu()
        UIView.animate(withDuration: kAnimationDuration) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.hamburgerMenuLeftConstraint.constant = strongSelf.viewModel.hamburgerMenuLeftConstraint
            strongSelf.hamburgerMenuOverflowView.isHidden = !strongSelf.viewModel.isHamburgerMenuExpanded
            strongSelf.view.layoutIfNeeded()
        } completion: { _ in
            guard let completion = completion else { return }
            completion()
        }
    }
    
    deinit {
        debugPrint(self.description + "Released From Memory")
    }
}

// MARK: - Hamburger Menu Delegate
extension HomeViewController: HamburgerMenuDelegate {
    func onSelectHamburgerMenu(type: HamburgerMenuItemType) {
        switch type {
        case .notifications:
            break
        case .myFiles:
            break
        case .trending:
            break
        case .store:
            break
        case .none:
            break
        }
    }
    
    func onTapViewProfile() {
        guard let profileViewController = ProfileViewController.initiateVC() else { return }
        viewModel.isHamburgerMenuExpanded = false
        expandOrCollapseHamburgerMenu { [weak self] in
            self?.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
}

extension HomeViewController: FigFilesTableViewCellDelegate {
    func didTapFullScreenOnVideo(avPlayer: AVPlayer) {
        let videoPlayerController = HomeScreenVideoPlayer()
        videoPlayerController.player = avPlayer
        self.present(videoPlayerController, animated: true)
    }
    
    func followOrUnfollowUser(userNameToFollowOrUnfollow: String) {
        let startIndex = 0
        let endIndex = figFilesTableView.viewModel.figFiles.count-1
        let arrayToIterate = startIndex...endIndex
        arrayToIterate.forEach { index in
            if figFilesTableView.viewModel.figFiles[index].ownerUsername == userNameToFollowOrUnfollow {
                figFilesTableView.viewModel.figFiles[index].isUserFollowing?.toggle()
            }
        }
    }
    
    func openProfileDetailsPage(userNameToPopulate: String) {
        guard let profileDetailsPage = UserProfileViewController.initiateVC() else { return }
        profileDetailsPage.userNameToPopulate = userNameToPopulate
        profileDetailsPage.figFilesTableViewCellDelegate = self
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

// MARK: - Like Comment Share Delegate
extension HomeViewController: LikeCommentShareDelegate {
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

// MARK: - FigFile TableView Delegate
extension HomeViewController: FigFileTableViewDelegate {
    func initialNetworkCallStarted() {
        showLoadingIndicator()
    }
    
    func initialNetworkCallFinishedWithNumberOfItems(newItems: Int) {
        hideLoadingIndicatorView()
    }
    
    func paginationCallStarted() {
        // Not Needed Now
    }
    
    func paginationCallEnded(newItems: Int) {
        // Not Needed Now
    }
}
