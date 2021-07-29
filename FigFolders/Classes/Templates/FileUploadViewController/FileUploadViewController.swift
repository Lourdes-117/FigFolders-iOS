//
//  FileUploadViewController.swift
//  FigFolders
//
//  Created by Lourdes on 7/25/21.
//

import UIKit

class FileUploadViewController: UIViewController {
// MARK: - Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var selectFileButton: UIButton!
    @IBOutlet weak var fileName: UITextField!
    @IBOutlet weak var fileDescription: TextViewWithPlaceholder!
    @IBOutlet weak var freeOrPaidSegment: UISegmentedControl!
    @IBOutlet weak var priceOfFile: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var titleBackgroundView: UIView!
    @IBOutlet weak var screenTitle: UILabel!
    
    let viewModel = FileUploadViewModel()

// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    private func initialSetup() {
        addObservers()
        screenTitle.text = viewModel.screenTitle
        selectFileButton.setRoundedCorners()
        
        selectFileButton.addBorder(color: viewModel.selectFileBorderColor!, width: 1)
        
        fileDescription.placeholder = viewModel.fileDescriptionPlaceholderText
        uploadButton.setRoundedCorners()
        fileDescription.layer.cornerRadius = 5
        fileDescription.addBorder(color: UIColor.gray.withAlphaComponent(0.5) , width: 0.5)
        backgroundView.roundCorners(corners: [.topLeft, .topRight], radius: viewModel.cornerRadius)
        titleBackgroundView.roundCorners(corners: [.topLeft, .topRight], radius: viewModel.cornerRadius)
        priceOfFile.isEnabled = viewModel.isPriceEnabled
        
        uploadButton.isEnabled = false
    }
    
    private func setupDelegates() {
        fileName.delegate = self
        fileDescription.delegate = self
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
// MARK: Helper Methods
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
// MARK: Button Tap Actions
    @IBAction private func onTapSelectFileButton() {
        if viewModel.isFileNameValid(fileName.text) && viewModel.isFileNameValid(fileDescription.text) {
            // ToDo: - Upload
        }
    }
    
    
    @IBAction private func onTapUploadButton() {
        if viewModel.isFileNameValid(fileName.text) && viewModel.isFileNameValid(fileDescription.text) {
            // ToDo: - Upload
        }
    }
    
    @IBAction func onSegmentValueChange(_ sender: Any) {
        viewModel.isFree.toggle()
        priceOfFile.isEnabled = viewModel.isPriceEnabled
        priceOfFile.text = ""
        if !viewModel.isPriceEnabled {
            view.endEditing(true)
        } else {
            priceOfFile.becomeFirstResponder()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        debugPrint(self.description + "Released From Memory")
    }
}

// MARK: - TextField Extension
extension FileUploadViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

// MARK: - TextView Extension
extension FileUploadViewController: UITextViewDelegate {
    
}
