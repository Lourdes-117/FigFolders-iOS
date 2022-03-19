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
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    let viewModel = AddCommentViewModel()
    
    var comment: FigFilesCommentsModel? {
        didSet {
            viewModel.commentModel = comment
        }
    }
    var fileUrl: String? {
        didSet {
            viewModel.fileUrl = fileUrl
        }
    }
    var fileOwner: String? {
        didSet {
            viewModel.fileOwner = fileOwner
        }
    }
    var indexPath: IndexPath? {
        didSet {
            viewModel.indexPath = indexPath
        }
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupDatasourceDelegate()
    }
    
    private func setupDatasourceDelegate() {
        commentTextView.delegate = self
    }
    
    private func setupView() {
        saveButton.isEnabled = false
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
        guard let newComment = commentTextView.text else { return }
        if viewModel.isCommentEditMode && viewModel.commentString == newComment { return } // Checking if comment has not been editted
        showLoadingIndicator()
        viewModel.addOrEditComment(newCommentString: newComment) { [weak self] _ in
            self?.hideLoadingIndicatorView()
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddCommentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let newComment = commentTextView.text else {
            saveButton.isEnabled = false
            return
        }
        if viewModel.commentString == newComment || newComment == "" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
}
