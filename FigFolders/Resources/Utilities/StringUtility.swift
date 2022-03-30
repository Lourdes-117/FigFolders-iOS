//
//  StringUtility.swift
//  FigFolders
//
//  Created by Lourdes on 5/14/21.
//

import Foundation

extension String {
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
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
    
    func trimmingTrailingSpaces() -> String {
        var string = self
        while string.hasSuffix(" ") {
            string = "" + string.dropLast()
        }
        return string
    }
    
    mutating func trimmedTrailingSpaces() {
        self = self.trimmingTrailingSpaces()
    }
}
