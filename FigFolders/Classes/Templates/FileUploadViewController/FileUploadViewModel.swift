//
//  FileUploadViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 7/25/21.
//

import UIKit
import MobileCoreServices

protocol FileUploadSelectionDelegate: AnyObject {
    func uploadFile(fileLocalUrl: URL, fileNameForDocumentPicker: String?, figFileModel: FigFileModel)
}

// MARK: - Text Validation Enum
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

// MARK: - Document Picker Enum
enum DocumentPickerDocumentType: String {
    // NOTE: Please add case to allIdentifiers and in fileTypeOfFileAtUrl(_ url: URL) when new case is added here
    case pdf = "pdf"
    case spreadsheet = "spreadsheet"
    case image = "image"
    case video = "video"
//    case text = "text"
//    case html = "html"
    case plainText = "plainText"
    
    var cfStringValue: CFString {
        switch self {
        case .pdf: return kUTTypePDF
        case .spreadsheet: return kUTTypeSpreadsheet
        case .image: return kUTTypeImage
        case .video: return kUTTypeVideo
//        case .text: return kUTTypeText
//        case .html: return kUTTypeHTML
        case .plainText: return kUTTypePlainText
        }
    }
    
    var identifierString: String {
        return String(self.cfStringValue)
    }
    
    static func fileTypeOfFileAtUrl(_ url: URL) -> DocumentPickerDocumentType? {
        /*
         Reference:
         https://medium.com/@francishart/swift-how-to-determine-file-type-4c46fc2afce8
         */
        let fileUtiArray: NSArray? = UTTypeCreateAllIdentifiersForTag(kUTTagClassFilenameExtension as CFString, url.pathExtension as CFString, nil)?.takeRetainedValue()
        guard fileUtiArray?.firstObject != nil else { return nil }
                
        let fileUti: CFString = fileUtiArray?.firstObject as! CFString
        
        if fileUti == DocumentPickerDocumentType.pdf.cfStringValue {
            return .pdf
        } else if fileUti == DocumentPickerDocumentType.spreadsheet.cfStringValue {
            return .spreadsheet
        } else if fileUti == DocumentPickerDocumentType.image.cfStringValue {
            return .image
        } else if fileUti == DocumentPickerDocumentType.video.cfStringValue {
            return .video
        }
//        else if fileUti == DocumentPickerDocumentType.text.cfStringValue {
//            return .text
//        }
//        else if fileUti == DocumentPickerDocumentType.html.cfStringValue {
//            return .html
//        }
        else if fileUti == DocumentPickerDocumentType.plainText.cfStringValue {
            return .plainText
        }
        
        return nil
    }
    
    static var allRawValues: [String] {
        [DocumentPickerDocumentType.pdf.rawValue,
         DocumentPickerDocumentType.spreadsheet.rawValue,
         DocumentPickerDocumentType.image.rawValue,
         DocumentPickerDocumentType.video.rawValue,
//         DocumentPickerDocumentType.text.rawValue,
//         DocumentPickerDocumentType.html.rawValue,
         DocumentPickerDocumentType.plainText.rawValue]
    }
    
    static var allIdentifier: [String] {
        [DocumentPickerDocumentType.pdf.identifierString,
         DocumentPickerDocumentType.spreadsheet.identifierString,
         DocumentPickerDocumentType.image.identifierString,
         DocumentPickerDocumentType.video.identifierString,
//         DocumentPickerDocumentType.text.identifierString,
//         DocumentPickerDocumentType.html.identifierString,
         DocumentPickerDocumentType.plainText.identifierString]
    }
    
    var pathToUpload: String? {
        return "\(StringConstants.shared.figFiles.currentUserFigFilesPath)\(self.rawValue)/"
    }
    
    var folderIconName: String {
        switch self {
        case .pdf:
            return "folder_pdf"
        case .spreadsheet:
            return "folder_spreadsheet"
        case .image:
            return "folder_image"
        case .video:
            return "folder_video"
        case .plainText:
            return "folder_text"
        }
    }
    
    var folderIcon: UIImage? {
        UIImage(named: folderIconName)
    }
}

// MARK: - File Import Source Enum
enum FileImportSource {
    case gallery
    case documents
}

// MARK: - File Upload ViewModel
class FileUploadViewModel {
    var selectedFileUrl: URL?
    var selectedFileType: DocumentPickerDocumentType?
    var isFree = true
    let cornerRadius: CGFloat = 38
    let selectFileBorderColor = ColorPalette.primary_green.color
    
    let screenTitle = "Upload File"
    let fileDescriptionPlaceholderText = "Add a description of your file here"
    let attachMediaTitle = "Select File To Upload"
    let attachMediaMessage = "Select where you want to upload file from"
    let photosString = "Photos"
    let videosString = "Videos"
    let cameraString = "Camera"
    let galleryString = "Gallery"
    let documents = "Browse"
    let cancel = "Cancel"
    
    let mediaTypeForVideo = "public.movie"
    
    let imageButtonTitle = "Image"
    let videoButtonTitle = "Video"
    
    // Filetypes allowed in Image picker. Note:- They'll be addded in return array of getMediaTypes(source: FileImportSource)
    private let mediaTypeMovieGallery = "public.movie"
    private let mediaTypeImageGallery = "public.image"
    
    func getMediaTypes(source: FileImportSource) -> [String] {
        switch source {
        case .gallery:
            return [mediaTypeMovieGallery, mediaTypeImageGallery]
        case .documents:
            return DocumentPickerDocumentType.allIdentifier
        }
    }
    
    let fileNotSelectedTitle = "No File Selected"
    let fileNotSelectedMessage = "Please select a file to upload"
    let okay = "okay"
    
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
    
    func isPriceValid(price: String?) -> Bool {
        if isFree {
            return true
        } else {
            guard let priceNonOptional = price,
                  !priceNonOptional.isEmpty,
                  let priceString = price as NSString?,
                  priceString.floatValue > 0.0 else {
                      return false
                  }
            return true
        }
    }
}
