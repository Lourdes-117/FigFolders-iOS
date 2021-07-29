//
//  HomeTabControllerViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 6/6/21.
//

import UIKit

class HomeTabControllerViewModel {
    let navigationTitleColor = LabelColorPalette.labelColorPrimary.color ?? UIColor()
    let navigationBarColor = ColorPalette.primary_green.color
    let centerButtonBackgroundColor = ColorPalette.primary_green.color
    let shadowOffset: CGSize = .zero
    let shadowColor = ColorPalette.greyscale4.color ?? UIColor()
    let shadowOpacity: Float = 1
    let shadowRadius: CGFloat = 5
    
    func centerButtonWidthHeightForTabBarHeight(tabbarHeight: CGFloat) -> CGFloat {
        var heightToReturn = tabbarHeight
        let bottomSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        heightToReturn += bottomSafeArea
        heightToReturn -= 0
        return heightToReturn
    }
}
