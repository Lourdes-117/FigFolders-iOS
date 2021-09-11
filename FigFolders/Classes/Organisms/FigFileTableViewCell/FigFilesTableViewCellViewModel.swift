//
//  FigFilesTableViewCellViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 9/11/21.
//

import UIKit

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
}
