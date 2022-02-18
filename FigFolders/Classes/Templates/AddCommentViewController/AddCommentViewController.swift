//
//  AddCommentViewController.swift
//  FigFolders
//
//  Created by Lourdes on 2/18/22.
//

import UIKit

class AddCommentViewController: ViewControllerWithLoading {
    
    // MARK: - Outlets
    @IBOutlet weak var commentTextView: UITextView!
    
    // MARK: - Attributes
    var comment: FigFilesCommentsModel? {
        didSet {
            viewModel.commentModel = comment
        }
    }
    
    let viewModel = AddCommentViewModel()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView() {
        self.title = viewModel.pageTitle
        commentTextView.text = viewModel.commentString
    }
    
    // MARK: - Button Tap Actions
    @IBAction func onTapCancelButton(_ sender: Any) {
        if commentTextView.text == viewModel.commentString {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let alert = UIAlertController(title: viewModel.areYouSureTitle, message: viewModel.areYouSureMessage, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: viewModel.yesText, style: .destructive) { [ weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        let noAction = UIAlertAction(title: viewModel.noText, style: .default)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onTapSaveButton(_ sender: Any) {
    }
}
