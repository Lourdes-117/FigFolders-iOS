//
//  SearchChatViewController.swift
//  FigFolders
//
//  Created by Lourdes on 6/5/21.
//

import UIKit

class SearchChatViewController: UIViewController {
    
    let viewModel = SearchChatViewModel()
    
// MARK: - Outlets
    @IBOutlet weak var pullDownTopBarView: PullDownTopBarView!
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        pullDownTopBarView.delegate = self
        pullDownTopBarView.titleString = viewModel.title
        
    }
}

// MARK: - Pull Down Top Bar Delegate
extension SearchChatViewController: PullDownTopBarViewDelegate {
    func onTapDismissButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
