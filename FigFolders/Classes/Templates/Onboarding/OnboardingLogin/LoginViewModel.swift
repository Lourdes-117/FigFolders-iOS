//
//  LoginViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 5/13/21.
//

import UIKit

protocol UserVerificationDelegate: NSObjectProtocol {
    func verificationSuccessful()
    func verificationFailed()
}

class LoginViewModel {
    let borderRadius: CGFloat = 5
    let borderWidth: CGFloat = 2
    let borderColor = UIColor.black
    
    let fieldValidColor = UIColor.green
    let fieldInvalidColor = UIColor.red
    
    let activityIndicatorBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    
    func isEmailValid(email: String?) -> Bool {
        guard let email = email,
              !email.isEmpty else { return false }
        return email.matchesRegex(StringConstants.shared.regex.email)
    }
    
    func isPasswordValid(password: String?) -> Bool {
        guard let password = password else { return false }
        return !password.isEmpty
    }
}
