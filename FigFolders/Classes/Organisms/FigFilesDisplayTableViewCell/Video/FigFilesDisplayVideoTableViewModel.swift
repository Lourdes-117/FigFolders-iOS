//
//  FigFilesDisplayVideoTableViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 1/18/22.
//

import Foundation

class FigFilesDisplayVideoTableViewModel {
    var figFile: FigFileModel?
    var indexPath: IndexPath?
    
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
