//
//  FileUploadViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 7/25/21.
//

import UIKit

enum TextLengthValidation {
    case short
    case long
    case valid
    
    var errorText: String {
        switch self {
        case .short:
            return "Too Short"
        case .long:
            return "Too Long"
        case .valid:
            return  "Valid"
        }
    }
}

class FileUploadViewModel {
    var isFree = true
    let screenTitle = "Upload File"
    let fileDescriptionPlaceholderText = "Add a description of your file here"
    let cornerRadius: CGFloat = 38
    let selectFileBorderColor = ColorPalette.primary_green.color
    let attachMediaTitle = "Select File To Upload"
    let attachMediaMessage = "Select where you want to upload file from"
    let photosAndVideos = "Photos and Videos"
    let cancel = "Cancel"
    let mediaTypeForVideo = "public.movie"
    let mediaTypeForImage = "public.image"
    let videoQualityType: UIImagePickerController.QualityType = .typeMedium
    let videoMaxLength = TimeInterval(600)
    
    var isPriceEnabled: Bool {
        return !isFree
    }
    
    func isFileNameValid(_ fileName: String?) -> TextLengthValidation {
        let minNumberOfCharsInFileName = 1
        let maxNumberOfCharsInFileName = 30
        guard let fileName = fileName else { return .short }
        let numberOfChars = fileName.trimmingCharacters(in: .whitespacesAndNewlines).count
        if numberOfChars <= minNumberOfCharsInFileName {
            return .short
        } else if numberOfChars >= maxNumberOfCharsInFileName {
            return .long
        } else {
            return .valid
        }
    }
    
    func isFileDescriptionValid(_ description: String?) -> TextLengthValidation {
        let maxNumberOfCharsInDescription = 150
        guard let description = description else { return .short }
        let numberOfChars = description.trimmingCharacters(in: .whitespacesAndNewlines).count
        if numberOfChars >= maxNumberOfCharsInDescription {
            return .long
        }
        return .valid
    }
}
