//
//  OnboardingRegisterStepOneViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 5/13/21.
//

import UIKit

class OnboardingRegisterStepOneViewModel {
    let borderRadius: CGFloat = 5
    let borderWidth: CGFloat = 2
    let borderColor = UIColor.black
    
    let fieldValidColor = UIColor.green
    let fieldInvalidColor = UIColor.red
    
    func isValidName(name: String?) -> Bool {
        guard let name = name else { return false }
        return name.matchesRegex(StringConstants.shared.regex.name)
    }
    
    func isValidPhoneNumber(number: String?) -> Bool {
        guard let number = number else { return false }
        return number.matchesRegex(StringConstants.shared.regex.phoneNumber)
    }
}
