//
//  HomeTapBarController.swift
//  FigFolders
//
//  Created by Lourdes on 5/16/21.
//

import UIKit

class HomeTabBarController: UITabBarController {
// MARK: - Outlets
    let uploadFileCenterButton = UIButton()
    
    let viewModel = HomeTabControllerViewModel()

// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = viewModel.navigationBarColor
        navigationController?.navigationBar.tintColor = viewModel.navigationTitleColor
        setupUploadButton()
    }
    
    private func setupUploadButton() {
        uploadFileCenterButton.addTarget(self, action: #selector(onTapUploadButton), for: .touchUpInside)
        let centerButtonWidthHeight = viewModel.centerButtonWidthHeightForTabBarHeight(tabbarHeight: tabBar.frame.height)
        uploadFileCenterButton.bounds = CGRect(x: 0, y: 0, width: centerButtonWidthHeight, height: centerButtonWidthHeight)
        uploadFileCenterButton.backgroundColor = viewModel.centerButtonBackgroundColor
        
        uploadFileCenterButton.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(uploadFileCenterButton)
        tabBar.centerXAnchor.constraint(equalTo: uploadFileCenterButton.centerXAnchor).isActive = true
        tabBar.topAnchor.constraint(equalTo: uploadFileCenterButton.topAnchor, constant: 8).isActive = true
        uploadFileCenterButton.widthAnchor.constraint(equalToConstant: centerButtonWidthHeight).isActive = true
        uploadFileCenterButton.heightAnchor.constraint(equalToConstant: centerButtonWidthHeight).isActive = true
        
        uploadFileCenterButton.setRoundedCorners()
        uploadFileCenterButton.addShadow(offset: viewModel.shadowOffset,
                                         color: viewModel.shadowColor,
                                         opacity: viewModel.shadowOpacity,
                                         radius: viewModel.shadowRadius)
    }
    
// MARK: - Button Tap Actions
    @objc func onTapUploadButton() {
        guard let fileUploadViewController = FileUploadViewController.initiateVC() else { return }
        self.present(fileUploadViewController, animated: true, completion: nil)
    }
}
