//
//  FolderViewCollectionViewCell.swift
//  FigFolders
//
//  Created by Lourdes on 1/21/22.
//

import UIKit

class FolderViewCollectionViewCell: UICollectionViewCell {
    static let kCellId = "FolderViewCollectionViewCell"
    
// MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var folderName: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    let viewModel = FolderViewCollectionViewCellViewModel()
    
// MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
// MARK: - SetupMethods
    func setupCell(cellType: DocumentPickerDocumentType) {
        folderName.text = cellType.rawValue.capitalized
        imageView.image = cellType.folderIcon
        cellBackgroundView.backgroundColor = viewModel.cellBackgroundColor
        cellBackgroundView.layer.cornerRadius = viewModel.cellCornerRadius
        contentView.backgroundColor = .clear
    }
}
