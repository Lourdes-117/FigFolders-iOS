//
//  ProfileViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 5/18/21.
//

import UIKit

class ProfileViewModel {
    var isEditEnabled = false
    
    let pageTitle = "My Profile"
    let editButtonShadowColor = UIColor.lightGray.cgColor
    let editButtonDhadowOpacity: Float = 1
    let editButtonShadowRadius: CGFloat = 10
    let editButtonCornerRadius: CGFloat = 5
    
    let logOutButtonTitle = "Log Out"
    let logOutButtonColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
    
    let saveButtonTitle = "Save"
    let saveButtonColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
    
    let logOutConfirmationTitle = "LogOut"
    let logOutConfirmationMessage = "Are You Sure You Want To Log Out?"
    let yes = "Yes"
    let no = "No"
}
