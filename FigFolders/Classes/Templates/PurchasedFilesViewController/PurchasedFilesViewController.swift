//
//  PurchasedFilesViewController.swift
//  FigFolders
//
//  Created by Lourdes Dinesh on 5/24/22.
//

import UIKit

class PurchasedFilesViewController: UIViewController {

    // MARK: - Private Properties
    let viewModel = PurchasedFilesViewModel()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        self.title = viewModel.pageTitle
    }
}
