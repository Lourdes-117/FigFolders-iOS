//
//  FigFilesDisplayImageTableViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 1/18/22.
//

import UIKit

class FigFilesDisplayImageTableViewModel {
    var figFile: FigFileModel?
    var indexPath: IndexPath?
    let profilePicPlaceholder = UIImage(systemName: "person.circle")
    
    var ownerName: String {
        figFile?.ownerUsername ?? ""
    }
    
    var fileTitle: String {
        figFile?.fileName ?? ""
    }
    
    var fileUrl: URL? {
        figFile?.fileUrlAsUrl
    }
    
    var fileUrlString: String? {
        figFile?.fileUrl
    }
    
    var isFileLikedByUser: Bool {
        return figFile?.likedUsers?.contains(currentUserUsername) ?? false
    }
}
