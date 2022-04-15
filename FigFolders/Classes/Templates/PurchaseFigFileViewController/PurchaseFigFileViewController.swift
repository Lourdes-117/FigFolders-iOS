//
//  PurchaseFigFileViewController.swift
//  FigFolders
//
//  Created by Lourdes on 4/15/22.
//

import UIKit

class PurchaseFigFileViewController: UIViewController {
    // MARK: - Public Properties
    var figFile: FigFileModel?
    
    // MARK: - Private Properties
    private let viewModel = PurchaseFigFileViewModel()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.pageTitle
    }
}
