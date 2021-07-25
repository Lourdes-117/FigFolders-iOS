//
//  HomeViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/16/21.
//

import UIKit
import FirebaseAuth

class HomeViewController: ViewControllerWithLoading {
// MARK: - Outlets
    @IBOutlet weak var hamburgerMenuView: HamburgerMenuView!
    @IBOutlet weak var hamburgerMenuLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var hamburgerMenuOverflowView: UIView!
    
    let viewModel = HomeViewControllerViewModel()
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        setUserDefaults()
        setupView()
        setupGestures()
        setupDelegate()
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
        showLoadingIndicator(with: .ballScaleMultiple, color: .blue)
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
                self?.hideLoadingIndicatorView()
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
