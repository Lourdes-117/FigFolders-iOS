//
//  HomeViewControllerViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 5/16/21.
//

import UIKit

class HomeViewControllerViewModel {
    let leftBarButtonImage = UIImage(named: "hamburger_menu_icon")?.withTintColor(UIColor.black) ?? UIImage()
    let rightBarButtonImage = UIImage(named: "chat_icon")?.withTintColor(UIColor.black) ?? UIImage()
    let pageTitle = "Home"
    let navigationTitleColor = LabelColorPalette.labelColorPrimary.color ?? UIColor()
    let navigationBarColor = ColorPalette.primary_green.color
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
