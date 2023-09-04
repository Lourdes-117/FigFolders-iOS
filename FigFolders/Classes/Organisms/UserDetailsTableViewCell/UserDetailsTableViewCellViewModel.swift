//
//  UserDetailsTableViewCellViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 9/13/21.
//

import UIKit

protocol UserProfileViewDelegate: AnyObject {
    func openProfileIconView(profilePicUrl: URL?)
}

class UserDetailsTableViewCellViewModel {
    var userName: String?
    let profilePicPlaceholder = UIImage(systemName: "person.circle")
    let profildPicBorderWidth: CGFloat = 1
    let profilePicBorderColor = ColorPalette.greyscale4.color?.cgColor
    
    var profilePicUrl: URL?
}
