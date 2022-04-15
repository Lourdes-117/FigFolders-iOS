//
//  AppAttestProvider.swift
//  FigFolders
//
//  Created by Lourdes on 4/15/22.
//

import Foundation
import Firebase
import FirebaseAppCheck

class FigFoldersAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        if #available(iOS 14.0, *) {
            return AppAttestProvider(app: app)
        } else {
            return DeviceCheckProvider(app: app)
        }
    }
}
