//
//  FigFileDisplayViewModel.swift
//  FigFileDisplayViewModel
//
//  Created by Lourdes on 9/14/21.
//

import UIKit

class FigFileDisplayViewModel {
    var figFile: FigFileModel?
    let temporaryUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/figfolders.appspot.com/o/FigFiles%2Flour_din%2Fimage%2Fsecond?alt=media&token=d771e427-21d1-4007-891f-40252f6ecadb")!
    
    var fileType: DocumentPickerDocumentType? {
        DocumentPickerDocumentType(rawValue: figFile?.fileType ?? "")
    }
    
    func getView() -> UIView {
        guard let fileType = fileType else { return UIView() }
        switch fileType {
        default:
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.sd_setImage(with: temporaryUrl, completed: nil)
            return imageView
        }
    }
}
