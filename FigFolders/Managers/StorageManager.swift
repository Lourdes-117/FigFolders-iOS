//
//  StorageManager.swift
//  FigFolders
//
//  Created by Lourdes on 5/30/21.
//

import Foundation
import FirebaseStorage

enum StorageErrors: Error {
    case failedToUpload
    case failedToDownload
}

class StorageManager {
    static let shared = StorageManager()
    
    private let storage: StorageReference = Storage.storage().reference()
    
    typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    /// Upload Profile Picture
    func uploadProfilePicture(username: String, image: UIImage, completion: @escaping UploadPictureCompletion) {
        let filePath = "\(StringConstants.shared.storage.profilePicturePath)\(username)"
        guard let data = image.jpegData(compressionQuality: JPEGQuality.high.rawValue) else { return }
        uploadImageAtPath(filePath: filePath, imageData: data, completion: completion)
    }
    
    
    /// Upload Any Picture To Particular Path
    fileprivate func uploadImageAtPath(filePath: String, imageData: Data, completion: @escaping UploadPictureCompletion) {
        storage.child(filePath).putData(imageData, metadata: nil) { [weak self] _, error in
            guard error == nil else {
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self?.storage.child(filePath).downloadURL { url, error in
                guard let url = url else {
                    debugPrint("Failed To Download Image")
                    completion(.failure(StorageErrors.failedToDownload))
                    return
                }
                let urlString = url.absoluteString
                debugPrint("download Url returned \(urlString)")
                completion(.success(urlString))
            }
        }
    }
}
