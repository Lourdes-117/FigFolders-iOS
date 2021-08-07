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
        fileUploadViewController.delegate = self
        self.present(fileUploadViewController, animated: true, completion: nil)
    }
}

// MARK: - File Upload Selection Delegate
extension HomeTabBarController: FileUploadSelectionDelegate {
    func uploadFile(fileLocalUrl: URL, fileNameForDocumentPicker: String?, figFileModel: FigFileModel) {
        let documentType = DocumentPickerDocumentType(rawValue: figFileModel.fileType ?? "") ?? .image
        let fileSizeInBytes = try? Data(contentsOf: fileLocalUrl).count
        
        var fileNameToSaveAs: String?
        if let localFilename = fileNameForDocumentPicker {
            let timeString = Date().toTimeString()
            fileNameToSaveAs = "\(timeString)_\(localFilename)"
        } else {
            let timeString = Date().toTimeString()
            fileNameToSaveAs = "\(timeString)_\(figFileModel.fileName ?? "")"
        }
        
        // Upload Fig File
        StorageManager.shared.uploadFigFile(localUrl: fileLocalUrl,
                                            fileName: fileNameToSaveAs ?? "",
                                            fileType: documentType) { result in
            switch result {
            case .success(let filePath):
                let figFileModelToUpload = FigFileModel(ownerUsername: figFileModel.ownerUsername,
                                                        fileName: figFileModel.fileName,
                                                        fileType: figFileModel.fileType,
                                                        fileDescription: figFileModel.fileDescription,
                                                        likedUsers: figFileModel.likedUsers,
                                                        fileUrl: filePath,
                                                        filePrice: figFileModel.filePrice,
                                                        comments: figFileModel.comments,
                                                        fileSizeBytes: fileSizeInBytes)
                // Update In Database
                DatabaseManager.shared.uploadFigFile(figFileModel: figFileModelToUpload) { isSuccess in
                    return
                }
            case .failure(let error):
                debugPrint("Error in Uploading File: \(error)")
            }
        }
    }
}
