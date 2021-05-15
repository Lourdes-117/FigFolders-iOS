//
//  EncodableUtility.swift
//  FigFolders
//
//  Created by Lourdes on 5/15/21.
//

import Foundation

extension Encodable {
    var toDictionnary: [String : Any]? {
        guard let data =  try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
