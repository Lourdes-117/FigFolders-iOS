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
    
    case overlay10
    case overlay20
    case overlay50
    case overlay60
    case overlay80
    case overlayAgnostic001
    case overlayAgnostic002
    case overlayAgnostic003
    case overlaygradient
    case overlaygradient2
    
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
        case .overlay10:
            return UIColor(named: "overlay10")
        case .overlay20:
            return UIColor(named: "overlay20")
        case .overlay50:
            return UIColor(named: "overlay50")
        case .overlay60:
            return UIColor(named: "overlay60")
        case .overlay80:
            return UIColor(named: "overlay80")
        case .overlayAgnostic001:
            return UIColor(named: "overlayAgnostic001")
        case .overlayAgnostic002:
            return UIColor(named: "overlayAgnostic002")
        case .overlayAgnostic003:
            return UIColor(named: "overlayAgnostic003")
        case .overlaygradient:
            return UIColor(named: "overlaygradient")
        case .overlaygradient2:
            return UIColor(named: "overlaygradient2")
        }
    }
}


enum LabelColorPalette {
    case labelColorPrimary
    case labelColorSecondary
    case labelColorTertiary
    case labelColorLink
    case labelColorRed
    case labelColorGreen
    
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
        case .labelColorGreen:
            return UIColor(named: "LabelColorGreen")
        }
    }
}
