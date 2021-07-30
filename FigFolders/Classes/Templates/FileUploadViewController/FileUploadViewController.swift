//
//  FileUploadViewController.swift
//  FigFolders
//
//  Created by Lourdes on 7/25/21.
//

import UIKit
import MobileCoreServices

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
    
    @IBOutlet weak var fileNameError: UILabel!
    @IBOutlet weak var fileDescriptionError: UILabel!
    
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
        resetErrorTexts()
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
    
    private func resetErrorTexts() {
        fileNameError.isHidden = true
        fileDescriptionError.isHidden = true
    }
    
// MARK: Button Tap Actions
    @IBAction private func onTapSelectFileButton() {
        let actionSheet = UIAlertController(title: viewModel.attachMediaTitle, message: viewModel.attachMediaMessage, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: viewModel.photosAndVideos, style: .default, handler: { [weak self] _ in
            self?.presentImageAndVideoPicker()
        }))
        
        actionSheet.addAction(UIAlertAction(title: viewModel.documents, style: .default, handler: { [weak self] _ in
            self?.presentDocumentPicker()
        }))
        
        actionSheet.addAction(UIAlertAction(title: viewModel.cancel, style: .cancel, handler: { _ in
            
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    @IBAction private func onTapUploadButton() {
        guard let selectedFileUrl = viewModel.selectedFileUrl else {
            let alert = UIAlertController(title: viewModel.fileNotSelectedTitle, message: viewModel.fileNotSelectedMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: viewModel.okay, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Fields Validation
        resetErrorTexts()
        let isFileNameValid = viewModel.isFileNameValid(fileName.text)
        let isFileDescriptionValid = viewModel.isFileDescriptionValid(fileDescription.text)
        if isFileNameValid == .valid && isFileDescriptionValid == .valid {
            // FileName and Description Valid
            
        } else {
            // Filename or Description Invalid
            if isFileNameValid != .valid {
                fileNameError.isHidden = false
            }
            if isFileDescriptionValid != .valid {
                fileDescriptionError.isHidden = false
            }
            
            fileNameError.text = isFileNameValid.errorText
            fileDescriptionError.text = isFileDescriptionValid.errorText
        }
        
        // TODO: - File Upload
    }
    
    private func presentImageAndVideoPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        picker.mediaTypes = viewModel.getMediaTypes(source: .gallery)
        picker.videoQuality = viewModel.videoQualityType
        picker.videoMaximumDuration = viewModel.videoMaxLength
        self.present(picker, animated: true, completion: nil)
    }
    
    private func presentDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: viewModel.getMediaTypes(source: .documents), in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.shouldShowFileExtensions = true
        self.present(documentPicker, animated: true, completion: nil)
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

// MARK: - ImagePicker ViewController Delegate
extension FileUploadViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let imageUrl = info[.imageURL] as? URL {
            debugPrint("Picked an image")
            viewModel.selectedFileUrl = imageUrl
            selectFileButton.setTitle("Image", for: .normal)
            selectFileButton.backgroundColor = viewModel.selectFileBorderColor
        } else if let videoUrl = info[.mediaURL] as? URL {
            debugPrint("Picked a video")
            viewModel.selectedFileUrl = videoUrl
            selectFileButton.setTitle("Video", for: .normal)
            selectFileButton.backgroundColor = viewModel.selectFileBorderColor
        }
    }
}

// MARK: - DocumentPicker Delegate
extension FileUploadViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        debugPrint("Document Picked")
        guard let fileUrl = urls.first else { return }
        viewModel.selectedFileUrl = fileUrl
        let fileType = DocumentPickerDocumentType.fileTypeOfFileAtUrl(fileUrl)
        
        selectFileButton.setTitle(fileUrl.lastPathComponent, for: .normal)
        selectFileButton.backgroundColor = viewModel.selectFileBorderColor
    }
}

// MARK: - NavigationController Delegate
extension FileUploadViewController: UINavigationControllerDelegate {
    
}
