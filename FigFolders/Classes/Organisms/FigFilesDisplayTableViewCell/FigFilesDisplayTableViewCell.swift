//
//  FigFilesDisplayTableViewCell.swift
//  FigFolders
//
//  Created by Lourdes on 1/18/22.
//

import Foundation
import UIKit

protocol FigFilesDisplayTableViewCell: UITableViewCell {
    func setupCell(figFile: FigFileModel)
    var figFilesTableViewCellDelegate: FigFilesTableViewCellDelegate? { get set }
}

protocol FigFilesTableViewCellDelegate: AnyObject {
    func openProfileDetailsPage(userNameToPopulate: String)
    func openFigFileLargeView(figFile: FigFileModel?)
}
