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
        NetworkManager.getData(randomFilesUrl, [FigFileModel].self) { result in
            completion(result)
        }
    }
    
    func getFigFilesOfUser(username: String, paginationIndex: Int, completion: @escaping ((Result<[FigFileModel], Error>) -> Void) ) {
        let figFilesOfUserUrlTemplate = String(format: UrlEndpoints.figFilesOfUserTemplateUrl, username, paginationIndex)
        let figFilesOfUserUrl = String(format: figFilesOfUserUrlTemplate, username, paginationIndex)
        NetworkManager.getData(figFilesOfUserUrl, [FigFileModel].self) { result in
            completion(result)
        }
    }
    
    func getUserFigFilesWithType(userName: String, paginationIndex: Int, documentType: DocumentPickerDocumentType, completion: @escaping ((Result<[FigFileModel], Error>) -> Void)) {
        let fileType = documentType.rawValue
        let randomFilesUrl = String(format: UrlEndpoints.userFigFilesWithFolderTypesTemplateurl, userName, fileType, paginationIndex)
        NetworkManager.getData(randomFilesUrl, [FigFileModel].self) { result in
            completion(result)
        }
    }
}
