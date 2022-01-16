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
}
