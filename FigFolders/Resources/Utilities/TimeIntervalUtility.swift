//
//  TimeIntervalUtility.swift
//  FigFolders
//
//  Created by Lourdes on 7/15/21.
//

import Foundation
extension TimeInterval {
    var minutesAndSeconds: String {
        let minutes = Int(self/60)
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        let secondStringToPrepend = seconds > 9 ? "" : "0"
        return "0\(minutes):\(secondStringToPrepend)\(seconds)"
    }
}
