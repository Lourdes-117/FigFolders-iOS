//
//  OnboardingRegisterStepTwoViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 5/13/21.
//

import UIKit

class OnboardingRegisterStepTwoViewModel {
    let borderRadius: CGFloat = 5
    let borderWidth: CGFloat = 2
    let borderColor = UIColor.black
    
    let gradientStartColor = UIColor.white
    let gradientEndColor = UIColor(red: 162, green: 227, blue: 196, alpha: 0)
    
    let fieldValidColor = UIColor.green
    let fieldInvalidColor = LabelColorPalette.labelColorRed.color ?? UIColor()
    
    let usernameNotAvailable = "Username Taken"
    let usernameAvailable = "Username Available"
    
    let emailIDNotAvailable = "Email-ID Already In Use"
    let emailIDAvailable = "Email-ID Available"
    
    let activityIndicatorBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    
    func isEmailValid(email: String?) -> Bool {
        guard let email = email,
              !email.isEmpty else { return false }
        return email.matchesRegex(StringConstants.shared.regex.email)
    }
    
    func isUsernameValid(username: String?) -> Bool {
        guard let username = username else { return false }
        return username.matchesRegex(StringConstants.shared.regex.userName)
    }
    
    func isPasswordValid(password: String?) -> Bool {
        guard let password = password,
              !password.isEmpty else { return false }
        let isPasswordLong = (password.count > 8) && (password.count < 25)
        
        let doesHaveLowerCase = password.first { character in
            character.isLowercase
        } != nil
        
        let doesHaveUpperCase = password.first { character in
            character.isUppercase
        } != nil
        
        return (doesHaveLowerCase && doesHaveUpperCase) && isPasswordLong
    }
}
