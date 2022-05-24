//
//  CloudFunctionsManager.swift
//  FigFolders
//
//  Created by Lourdes on 1/16/22.
//

import Foundation
import Alamofire

class CloudFunctionsManager {
    private init() { }
    static let shared = CloudFunctionsManager()
    
    func likePostByUser(figFileLikeModel: FigFileLikeModel) {
        guard let url = URL(string: UrlEndpoints.likePostByUser) else { return }
        debugPrint("Requested url - \(url.absoluteString)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = StringConstants.shared.httpMethodConstants.postMethod
        urlRequest.addValue(StringConstants.shared.httpMethodConstants.applicationJson, forHTTPHeaderField: StringConstants.shared.httpMethodConstants.contentType)
        do {
            urlRequest.httpBody = try JSONEncoder().encode(figFileLikeModel)
        } catch {
            return
        }
        URLSession.shared.dataTask(with: urlRequest).resume()
    }
    
    func markConversationAsRead(markMessageAsReadModel: MarkMessageAsReadModel) {
        guard let url = URL(string: UrlEndpoints.markMessageAsRead) else { return }
        debugPrint("Requested url - \(url.absoluteString)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = StringConstants.shared.httpMethodConstants.postMethod
        urlRequest.addValue(StringConstants.shared.httpMethodConstants.applicationJson, forHTTPHeaderField: StringConstants.shared.httpMethodConstants.contentType)
        do {
            urlRequest.httpBody = try JSONEncoder().encode(markMessageAsReadModel)
        } catch {
            return
        }
        URLSession.shared.dataTask(with: urlRequest).resume()
    }
    
    func getRandomFigFiles(completion: @escaping ((Result<[FigFileModel], Error>) -> Void)) {
        let randomFilesUrl = String(format: UrlEndpoints.randomFilesTemplateUrl, currentUserUsername ?? "")
        debugPrint("Requested url - \(randomFilesUrl)")
        NetworkManager.getData(randomFilesUrl, [FigFileModel].self) { result in
            completion(result)
        }
    }
    
    func getFigFilesOfUser(username: String, paginationIndex: Int, completion: @escaping ((Result<[FigFileModel], Error>) -> Void) ) {
        let figFilesOfUserUrlTemplate = String(format: UrlEndpoints.figFilesOfUserTemplateUrl, username, paginationIndex, currentUserUsername ?? "")
        let figFilesOfUserUrl = String(format: figFilesOfUserUrlTemplate, username, paginationIndex)
        debugPrint("Requested url - \(figFilesOfUserUrl)")
        NetworkManager.getData(figFilesOfUserUrl, [FigFileModel].self) { result in
            completion(result)
        }
    }
    
    func getUserFigFilesWithType(userName: String, paginationIndex: Int, documentType: DocumentPickerDocumentType, completion: @escaping ((Result<[FigFileModel], Error>) -> Void)) {
        let fileType = documentType.rawValue
        let randomFilesUrl = String(format: UrlEndpoints.userFigFilesWithFolderTypesTemplateurl, userName, fileType, paginationIndex)
        debugPrint("Requested url - \(randomFilesUrl)")
        NetworkManager.getData(randomFilesUrl, [FigFileModel].self) { result in
            completion(result)
        }
    }
    
    func getFigFileComments(fileOwner: String, fileUrl: String, paginationIndex: Int, completion: @escaping ((Result<[FigFilesCommentsModel], Error>) -> Void)) {
        let figFileCommentUrl = String(format: UrlEndpoints.getCommentWithPaginationTemplateurl, paginationIndex)
        guard let url = URL(string: figFileCommentUrl) else { return }
        debugPrint("Requested url - \(url.absoluteString)")
        var urlRequest = URLRequest(url: url)
        do {
            let getCommentsModel = GetCommentsModel()
            getCommentsModel.fileOwner = fileOwner
            getCommentsModel.fileUrl = fileUrl
            urlRequest.httpBody = try JSONEncoder().encode(getCommentsModel)
        } catch {
            completion(.failure(error))
            return
        }
        urlRequest.httpMethod = StringConstants.shared.httpMethodConstants.postMethod
        urlRequest.addValue(StringConstants.shared.httpMethodConstants.applicationJson, forHTTPHeaderField: StringConstants.shared.httpMethodConstants.contentType)
        URLSession.shared.dataTask(with: urlRequest) { data, _ , error in
            guard let data = data, error == nil else {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
                return
            }
            // Got Data, Have to parse it
            let result = NetworkManager.getParsedData([FigFilesCommentsModel].self, data)
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()
    }
    
    func addCommentsForFile(addCommentModel: AddCommentModel, completion: @escaping (Bool) -> Void) {
        guard let addCommentUrl = URL(string: UrlEndpoints.addCommentUrl) else {
            completion(false)
            return
        }
        debugPrint("Requested url - \(addCommentUrl.absoluteString)")
        var urlRequest = URLRequest(url: addCommentUrl)
        urlRequest.httpMethod = StringConstants.shared.httpMethodConstants.postMethod
        urlRequest.addValue(StringConstants.shared.httpMethodConstants.applicationJson, forHTTPHeaderField: StringConstants.shared.httpMethodConstants.contentType)
        do {
            urlRequest.httpBody = try JSONEncoder().encode(addCommentModel)
        } catch {
            completion(false)
            return
        }
        URLSession.shared.dataTask(with: urlRequest) { data, _ , error in
            guard data != nil,
                  error == nil else {
                      DispatchQueue.main.async {
                          completion(false)
                      }
                      return
                  }
            DispatchQueue.main.async {
                completion(true)
            }
        }.resume()
    }
    
    func editCommentsForFiles(editCommentModel: AddCommentModel, completion: @escaping (Bool) -> Void) {
        guard let editCommentUrl = URL(string: UrlEndpoints.editCommentUrl) else {
            completion(false)
            return
        }
        debugPrint("Requested url - \(editCommentUrl.absoluteString)")
        var urlRequest = URLRequest(url: editCommentUrl)
        urlRequest.httpMethod = StringConstants.shared.httpMethodConstants.postMethod
        urlRequest.addValue(StringConstants.shared.httpMethodConstants.applicationJson, forHTTPHeaderField: StringConstants.shared.httpMethodConstants.contentType)
        do {
            urlRequest.httpBody = try JSONEncoder().encode(editCommentModel)
        } catch {
            completion(false)
            return
        }
        URLSession.shared.dataTask(with: urlRequest) { data, response , error in
            guard data != nil,
                  error == nil else {
                      DispatchQueue.main.async {
                          completion(false)
                      }
                      return
                  }
            DispatchQueue.main.async {
                completion(true)
            }
        }.resume()
    }
    
    func followOrUnfollowUser(userNameToFollow: String) {
        guard let followUserUrl = URL(string: UrlEndpoints.followUser) else { return }
        debugPrint("Requested url - \(followUserUrl.absoluteString)")
        
        let followUserModel = FollowUserModel(currentUser: currentUserUsername, userToFollow: userNameToFollow)
        
        var urlRequest = URLRequest(url: followUserUrl)
        urlRequest.httpMethod = StringConstants.shared.httpMethodConstants.postMethod
        urlRequest.addValue(StringConstants.shared.httpMethodConstants.applicationJson, forHTTPHeaderField: StringConstants.shared.httpMethodConstants.contentType)
        do {
            urlRequest.httpBody = try JSONEncoder().encode(followUserModel)
        } catch {
            return
        }
        URLSession.shared.dataTask(with: urlRequest) { _, _ , _ in
        }.resume()
    }
    
    func searchUsers(queryUserName: String, pagination: Int, completion: @escaping (Result<[String], Error>) -> Void ) {
        let searchUsersUrl = String(format: UrlEndpoints.searchUsers, queryUserName, pagination)
        debugPrint("Requested url - \(searchUsersUrl)")
        NetworkManager.getData(searchUsersUrl, [String].self) { result in
            completion(result)
        }
    }
}
