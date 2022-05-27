//
//  FigFileLikeModel.swift.swift
//  FigFolders
//
//  Created by Lourdes on 1/16/22.
//

import Foundation

class FigFileLikeModel: Encodable {
    var fileOwner: String?
    var fileUrl: String?
    var currentUser: String?
}

class MarkMessageAsReadModel: Encodable {
    var conversationId: String?
    var userName: String?
}

class GetCommentsModel: Encodable {
    var fileOwner: String?
    var fileUrl: String?
}

class AddCommentModel: Encodable {
    var userName: String?
    var commentString: String?
    var commentAddedDate: String?
    var commentId: String?
    var fileOwner: String?
    var fileUrl: String?
}

struct FollowUserModel: Encodable {
    var currentUser: String?
    var userToFollow: String?
}

struct StorageUsedModel: Codable {
    var figFilesStorageUsed: String?
    var maxStorateInMegabytes: String?
}
