//
//  ColorPalette.swift
//  FigFolders
//
//  Created by Lourdes on 6/6/21.
//

import UIKit

enum ColorPalette {
    case primary_green
    case greyscale1
    case greyscale2
    case greyscale3
    case greyscale4
    case greyscale5
    case greyscale6
    
    var color: UIColor? {
        switch self {
        case .primary_green:
            return UIColor(named: "Primary-Green")
        case .greyscale1:
            return UIColor(named: "Greyscale1")
        case .greyscale2:
            return UIColor(named: "Greyscale2")
        case .greyscale3:
            return UIColor(named: "Greyscale3")
        case .greyscale4:
            return UIColor(named: "Greyscale4")
        case .greyscale5:
            return UIColor(named: "Greyscale5")
        case .greyscale6:
            return UIColor(named: "Greyscale6")
        }
    }
}


enum LabelColorPalette {
    case labelColorPrimary
    case labelColorSecondary
    case labelColorTertiary
    case labelColorLink
    case labelColorRed
    
    var color: UIColor? {
        switch self {
        case .labelColorPrimary:
            return UIColor(named: "LabelColorPrimary")
        case .labelColorSecondary:
            return UIColor(named: "LabelColorSecondary")
        case .labelColorTertiary:
            return UIColor(named: "LabelColorTertiary")
        case .labelColorLink:
            return UIColor(named: "LabelColorLink")
        case .labelColorRed:
            return UIColor(named: "LabelColorRed")
        }
    }
}
