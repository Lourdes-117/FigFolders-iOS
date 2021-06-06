//
//  HomeTapBarController.swift
//  FigFolders
//
//  Created by Lourdes on 5/16/21.
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    let viewModel = HomeTabControllerViewModel()

// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = viewModel.navigationBarColor
        navigationController?.navigationBar.tintColor = viewModel.navigationTitleColor
    }
}
