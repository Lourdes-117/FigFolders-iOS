//
//  EncodableUtility.swift
//  FigFolders
//
//  Created by Lourdes on 5/15/21.
//

import Foundation

extension Encodable {
    var toDictionary: [String : Any]? {
        guard let data =  try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
    
    func decodeDictAsClass<T>(type: T.Type) -> T? where T: Decodable {
        do {
            let data = try JSONEncoder().encode(self)
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            return nil
        }
    }
}
