//
//  OnboardingCollectionViewCell.swift
//  FigFolders
//
//  Created by Lourdes on 5/10/21.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var contentFirstLine: UILabel!
    @IBOutlet weak var contentSecondLine: UILabel!
    
    static let kIdentifier = "OnboardingCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(title: String, firstLine: String, secondLine: String) {
        cellTitle.text = title
        contentFirstLine.text = firstLine
        contentSecondLine.text = secondLine
    }
}
