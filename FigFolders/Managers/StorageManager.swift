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
    
    /// Uploadd Video With URL
    fileprivate func uploadVideoWithURL(filePath: String, fileURL: URL, completion: @escaping UploadPictureCompletion) {
        
        storage.child(filePath).putFile(from: fileURL, metadata: nil) { [weak self] _, error in
            guard error == nil else {
                //failed
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self?.storage.child(filePath).downloadURL(completion: { url, error in
                guard let url = url else {
                    debugPrint("Failed To Download Image")
                    completion(.failure(StorageErrors.failedToDownload))
                    return
                }
                let urlString = url.absoluteString
                debugPrint("download Url returned \(urlString)")
                completion(.success(urlString))
            })
        }
    }
    
    /// Upload Message Photo
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        let filePath = "\(StringConstants.shared.storage.messageImagesPath)\(fileName)"
        uploadImageAtPath(filePath: filePath, imageData: data, completion: completion)
    }
    
    /// Upload Video Or File With URL
    public func uploadMessageVideo(with url: URL, fileName: String, completion: @escaping UploadPictureCompletion) {
        let filePath = "\(StringConstants.shared.storage.messageVideosPath)\(fileName)"
        uploadVideoWithURL(filePath: filePath, fileURL: url, completion: completion)
    }
}
