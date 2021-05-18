//
//  ProfileViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/18/21.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

// MARK: - Outlets
    
    let viewModel = ProfileViewModel()
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        setupView()
    }
    
    private func setupView() {
        self.title = viewModel.pageTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}
