//
//  FigFileProfileViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 1/18/22.
//

import Foundation

class FigFileProfileViewModel {
    var figFile: FigFileModel?
    
    var fileOwnerName: String {
        figFile?.ownerUsername ?? ""
    }
}
