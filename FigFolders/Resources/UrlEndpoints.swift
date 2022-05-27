//
//  UrlEndpoints.swift.swift
//  FigFolders
//
//  Created by Lourdes on 1/16/22.
//

import Foundation

struct UrlEndpoints {
    static let randomFilesTemplateUrl = "https://us-central1-figfolders-30b48.cloudfunctions.net/getRandomFigFilesForUser?userName=%@"
    static let figFilesOfUserTemplateUrl = "https://us-central1-figfolders-30b48.cloudfunctions.net/getFigFilesOfUser?userName=%@&pagination=%d&currentUserName=%@"
    static let likePostByUser = "https://us-central1-figfolders-30b48.cloudfunctions.net/likePostByUser"
    static let markMessageAsRead = "https://us-central1-figfolders-30b48.cloudfunctions.net/markMessagesAsRead"
    static let userFigFilesWithFolderTypesTemplateurl = "https://us-central1-figfolders-30b48.cloudfunctions.net/getFigFilesOfUserWithType?userName=%@&fileType=%@&pagination=%d"
    static let getCommentWithPaginationTemplateurl = "https://us-central1-figfolders-30b48.cloudfunctions.net/getCommentWithPagination?pagination=%d"
    static let addCommentUrl = "https://us-central1-figfolders-30b48.cloudfunctions.net/addCommentsForFile"
    static let editCommentUrl = "https://us-central1-figfolders-30b48.cloudfunctions.net/editCommentForFile"
    static let followUser = "https://us-central1-figfolders-30b48.cloudfunctions.net/followUser"
    static let searchUsers = "https://us-central1-figfolders-30b48.cloudfunctions.net/searchUser?queryUserName=%@&pagination=%d"
    static let getStorageConsumptionOfUser = "https://us-central1-figfolders-30b48.cloudfunctions.net/getStorageConsumptionOfUser?userName=%@"
}
