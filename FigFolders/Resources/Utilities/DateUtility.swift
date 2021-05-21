//
//  DateUtility.swift
//  FigFolders
//
//  Created by Lourdes on 5/15/21.
//

import UIKit

let kDateFormatMMddyyyy = "MM/dd/yyyy"

extension Date {
    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDateFormatMMddyyyy
        return dateFormatter.string(from: self)
    }
}
