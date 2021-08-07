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
    
    /// returns hours-minutes-seconds
    func toTimeString() -> String {
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let seconds = calendar.component(.second, from: self)
        
        return "\(hour)-\(minutes)-\(seconds)"
    }
}
