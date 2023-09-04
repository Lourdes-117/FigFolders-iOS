//
//  HomeTapBarController.swift
//  FigFolders
//
//  Created by Lourdes on 5/16/21.
//

import UIKit

class HomeTabBarController: UITabBarController {
    let viewModel = HomeTabControllerViewModel()
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatasourceDelegates()
        setupNavigationBar()
    }
    
    private func setupDatasourceDelegates() {
        self.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = viewModel.navigationBarColor
        navigationController?.navigationBar.tintColor = viewModel.navigationTitleColor
        setupUploadButton()
    }
    
    private func setupUploadButton() {
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowColor = viewModel.tabBarShadowColor
        tabBar.layer.shadowOpacity = 0.3
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
        // Check if space available for user
        var selectedFileSize: Float
        do {
            selectedFileSize = Float(try fileLocalUrl.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0)/1000000
        } catch {
            debugPrint("Error Uploading File \(error)")
            return
        }
        DatabaseManager.shared.getUserDetailsForUsername(username: currentUserUsername ?? "") { [weak self] userDetailsModel in
            guard let strongSelf = self else { return }
            guard let userDetailsModel = userDetailsModel,
                  let maxStorateInMegabytes = userDetailsModel.maxStorateInMegabytes else { // Failed To Fetch User Model
                let errorAlert = UIAlertController(title: strongSelf.viewModel.errorString, message: strongSelf.viewModel.pleaseTryAgainString, preferredStyle: .alert)
                let alertOkayButton = UIAlertAction(title: strongSelf.viewModel.okayString, style: .default, handler: nil)
                errorAlert.addAction(alertOkayButton)
                strongSelf.present(errorAlert, animated: true, completion: nil)
                return
            }
            if ((userDetailsModel.figFilesStorageUsed ?? 0.0) + selectedFileSize) > maxStorateInMegabytes {
                // Space Not Available For User
                let errorAlert = UIAlertController(title: strongSelf.viewModel.errorString, message: strongSelf.viewModel.notEnoughSpaceAvailable, preferredStyle: .alert)
                let alertOkayButton = UIAlertAction(title: strongSelf.viewModel.okayString, style: .default, handler: nil)
                errorAlert.addAction(alertOkayButton)
                strongSelf.present(errorAlert, animated: true, completion: nil)
                return
            } else { //Space Available
                // Upload File
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
                        // Update Used Storage
                        DatabaseManager.shared.updateStorageSpaceUsedByUserWithNewFileSize(newFileSize: selectedFileSize)
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
    }
}

// MARK: - Tab Bar Controller Delegate
extension HomeTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController as? DummyFileUploadViewController != nil {
            onTapUploadButton()
            return false
        }
        return true
    }
}
