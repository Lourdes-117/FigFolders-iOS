//
//  HomeViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/16/21.
//

import UIKit

class HomeViewController: UIViewController {
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
        setupView()
        setupGestures()
    }
    
    private func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: viewModel.leftBarButtonImage , style: .plain, target: self, action: #selector(onTapLeftBarButtonItem))
        navigationController?.navigationBar.barTintColor = viewModel.navigationBarColor
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
    
// MARK: - Button Actions
    @objc private func onTapOverflowView() {
        viewModel.isHamburgerMenuExpanded = false
        expandOrCollapseHamburgerMenu()
    }
    
    @objc private func onTapLeftBarButtonItem() {
        viewModel.isHamburgerMenuExpanded.toggle()
        expandOrCollapseHamburgerMenu()
    }
    
// MARK: - Helper Methods
    private func expandOrCollapseHamburgerMenu() {
        UIView.animate(withDuration: kAnimationDuration) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.hamburgerMenuLeftConstraint.constant = strongSelf.viewModel.hamburgerMenuLeftConstraint
            strongSelf.hamburgerMenuOverflowView.isHidden = !strongSelf.viewModel.isHamburgerMenuExpanded
            strongSelf.view.layoutIfNeeded()
        }
    }
}


