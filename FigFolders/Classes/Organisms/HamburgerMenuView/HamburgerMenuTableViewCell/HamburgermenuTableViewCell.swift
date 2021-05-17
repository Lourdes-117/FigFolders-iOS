//
//  HamburgermenuTableViewCell.swift
//  FigFolders
//
//  Created by Lourdes on 5/18/21.
//

import UIKit

class HamburgermenuTableViewCell: UITableViewCell {
    static let kIdentifier = "HamburgermenuTableViewCell"
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(type: HamburgerMenuItemType) {
        title.text = type.getTitle()
        icon.image = UIImage(named: type.getIconName())
    }
}
