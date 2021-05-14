//
//  StringConstants.swift
//  FigFolders
//
//  Created by Lourdes on 5/14/21.
//

import Foundation

class StringConstants {
    static let shared = StringConstants()

    //Constants
    let regex = RegexConstants()
}

struct RegexConstants {
    let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let name = "^[A-Za-z]\\w{1,29}$"
    let phoneNumber = "^(\\+\\d{1,2}\\s?)?1?\\-?\\.?\\s?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}$"
    let userName = "^[a-zA-Z0-9](_(?!(\\.|_))|\\.(?!(_|\\.))|[a-zA-Z0-9]){6,18}[a-zA-Z0-9]$"
}
