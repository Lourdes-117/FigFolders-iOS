//
//  HomeViewControllerViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 5/16/21.
//

import UIKit

class HomeViewControllerViewModel {
    let leftBarButtonImage = UIImage(named: "hamburger_menu_icon")?.withTintColor(UIColor.black) ?? UIImage()
    let pageTitle = "Home"
    let navigationBarColor = UIColor(red: 26, green: 214, blue: 70, alpha: 1)
    let navigationIconsColor = UIColor.black
    
    var isHamburgerMenuExpanded = false
    
    var hamburgerMenuLeftConstraint: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        if isHamburgerMenuExpanded {
            return screenWidth * 0.1
        } else {
            return screenWidth
        }
    }
}
