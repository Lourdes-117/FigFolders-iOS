//
//  NetworkManager.swift
//  FigFolders
//
//  Created by Lourdes on 9/11/21.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURLRequest
    case parsingError
    case noData
}

class NetworkManager {
    
    static func canacelRequst(_ url: String) {
    }
    
    static func getData<T>(_ url: String, _ modelType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        let networkCallTimeout: Int = 10
        
        debugPrint("Requested url - \(url)")
        AF.request(url) {
            $0.timeoutInterval = TimeInterval(networkCallTimeout)
            $0.cachePolicy = .reloadIgnoringLocalCacheData
        }
            .validate()
            .response { (data) in
                switch data.result {
                case .success(let data):
                    completion(NetworkManager.getParsedData(modelType, data))
                case .failure(let error):
                    debugPrint(error)
                    completion(.failure(error))
                }
        }
    }
    
    static func getParsedData<T>(_ modelType: T.Type, _ data: Data?) -> Result<T, Error> where T: Decodable {
        guard let receivedData = data else {
            return .failure(NetworkError.noData)
        }
        
        let jsonDecoder = JSONDecoder()
        do {
            let data = try jsonDecoder.decode(modelType, from: receivedData)
            return .success(data)
        } catch let exception {
            return .failure(exception)
        }
    }
    
}
    
