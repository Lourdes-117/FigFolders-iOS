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
    
    typealias UploadFileCompletion = (Result<String, Error>) -> Void
    
    /// Upload Profile Picture
    func uploadProfilePicture(username: String, image: UIImage, completion: @escaping UploadFileCompletion) {
        let filePath = "\(StringConstants.shared.storage.profilePicturePath)\(username)"
        guard let data = image.jpegData(compressionQuality: JPEGQuality.high.rawValue) else { return }
        uploadImageAtPath(filePath: filePath, imageData: data, completion: completion)
    }
    
    
    /// Upload Any Picture To Particular Path
    fileprivate func uploadImageAtPath(filePath: String, imageData: Data, completion: @escaping UploadFileCompletion) {
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
    
    /// Upload Video With URL
    fileprivate func uploadFileWithUrl(filePath: String, fileURL: URL, completion: @escaping UploadFileCompletion) {
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
    func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadFileCompletion) {
        let filePath = "\(StringConstants.shared.storage.messageImagesPath)\(fileName)"
        uploadImageAtPath(filePath: filePath, imageData: data, completion: completion)
    }
    
    /// Upload Video Or File With URL
    func uploadMessageVideo(from url: URL, fileName: String, completion: @escaping UploadFileCompletion) {
        let filePath = "\(StringConstants.shared.storage.messageVideosPath)\(fileName)"
        uploadFileWithUrl(filePath: filePath, fileURL: url, completion: completion)
    }
    
    /// Upload Audio Message
    func uploadMessageAudio(from url: URL, fileName: String, completion: @escaping UploadFileCompletion) {
        let filePath = "\(StringConstants.shared.storage.messageAudioPath)\(fileName)"
        uploadFileWithUrl(filePath: filePath, fileURL: url, completion: completion)
    }
    
    /// Download File With Url
    func downloadFileWithUrl(_ url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let reference = Storage.storage().reference(forURL: url.absoluteString)
        reference.getData(maxSize: 1 * 1024 * 1024, completion: completion)
    }
    
    func downloadAudioWithName(_ name: String, completion: @escaping (Data?, Error?) -> Void) {
        storage.child("\(StringConstants.shared.storage.messageAudioPath)\(name)").getData(maxSize: 2 * 1024 * 1024, completion: completion)
    }
}
