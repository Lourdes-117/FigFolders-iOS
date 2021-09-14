//
//  FigFilesTableViewCellViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 9/11/21.
//

import UIKit

protocol FigFilesTableViewCellDelegate: AnyObject {
    func openProfileDetailsPage(userNameToPopulate: String)
}

class FigFilesTableViewCellViewModel {
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
}
