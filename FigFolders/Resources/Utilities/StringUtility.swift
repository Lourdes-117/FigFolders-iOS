//
//  StringUtility.swift
//  FigFolders
//
//  Created by Lourdes on 5/14/21.
//

import Foundation

extension String {
    func matchesRegex(_ regexString: String) -> Bool {
        let regex = NSPredicate(format:"SELF MATCHES %@", regexString)
        return regex.evaluate(with: self)
    }
    
    func toDateObject() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDateFormatMMddyyyy
        let dateObject = dateFormatter.date(from: self)
        return dateObject
    }
}
