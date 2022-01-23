//
//  UrlEndpoints.swift.swift
//  FigFolders
//
//  Created by Lourdes on 1/16/22.
//

import Foundation

struct UrlEndpoints {
    static let randomFilesTemplateUrl = "https://us-central1-figfolders-30b48.cloudfunctions.net/getRandomFigFilesForUser"
    static let figFilesOfUserTemplateUrl = "https://us-central1-figfolders-30b48.cloudfunctions.net/getFigFilesOfUser?userName=%@&pagination=%d"
    static let likePostByUser = "https://us-central1-figfolders-30b48.cloudfunctions.net/likePostByUser"
    static let markMessageAsRead = "https://us-central1-figfolders-30b48.cloudfunctions.net/markMessagesAsRead"
    static let userFigFilesWithFolderTypesTemplateurl = "https://us-central1-figfolders-30b48.cloudfunctions.net/getFigFilesOfUserWithType?userName=%@&fileType=%@&pagination=%d"
}
