//
//  FolderViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 1/21/22.
//

import Foundation

class FolderViewModel {
    let allCellTypes = DocumentPickerDocumentType.allRawValues
    let pageTitle = "Fig Folders"
    
    var numberOfCells: Int {
        allCellTypes.count
    }
    
    func getCellTypeForString(cellType: String) -> DocumentPickerDocumentType {
        DocumentPickerDocumentType(rawValue: cellType) ?? .image
    }
    
    func getCellTypeAtIndex(index: Int) -> DocumentPickerDocumentType {
        guard let cellTypeString = allCellTypes.getObjectSafely(index),
              let cellType = DocumentPickerDocumentType(rawValue: cellTypeString) else {
                  return .image
              }
        return cellType
    }
}
