//
//  DateUtility.swift
//  FigFolders
//
//  Created by Lourdes on 5/15/21.
//

import UIKit

extension Date {
    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: self)
    }
}
