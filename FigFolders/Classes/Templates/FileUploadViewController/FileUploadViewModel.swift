//
//  FileUploadViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 7/25/21.
//

import UIKit

class FileUploadViewModel {
    var isFree = true
    let screenTitle = "Upload File"
    let fileDescriptionPlaceholderText = "Add a description of your file here"
    let cornerRadius: CGFloat = 38
    let selectFileBorderColor = ColorPalette.primary_green.color
    
    var isPriceEnabled: Bool {
        return !isFree
    }
    
    func isFileNameValid(_ fileName: String?) -> Bool {
        let minNumberOfCharsInFileName = 1
        let maxNumberOfCharsInFileName = 30
        guard let fileName = fileName else { return false }
        let numberOfChars = fileName.trimmingCharacters(in: .whitespacesAndNewlines).count
        if numberOfChars >= minNumberOfCharsInFileName && numberOfChars <= maxNumberOfCharsInFileName {
            return true
        }
        return false
    }
    
    func isDescriptionValid(_ description: String?) -> Bool {
        let maxNumberOfCharsInDescription = 150
        guard let description = description else { return false }
        let numberOfChars = description.trimmingCharacters(in: .whitespacesAndNewlines).count
        if numberOfChars <= maxNumberOfCharsInDescription {
            return true
        }
        return false
    }
}
