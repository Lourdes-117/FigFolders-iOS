//
//  ResetPasswordViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 5/13/21.
//

import UIKit

class ResetPasswordViewModel {
    let borderRadius: CGFloat = 5
    let borderWidth: CGFloat = 2
    let borderColor = UIColor.black
    
    let gradientStartColor = UIColor.white
    let gradientEndColor = UIColor(red: 162, green: 227, blue: 196, alpha: 0)
    
    let fieldValidColor = UIColor.green
    let fieldInvalidColor = LabelColorPalette.labelColorRed.color ?? UIColor()
    
    let userNotFound = "User with email not found"
    let passwordResetLinkSent = "Password reset link sent"
    
    func isEmailValid(email: String?) -> Bool {
        guard let email = email,
              !email.isEmpty else { return false }
        return email.matchesRegex(StringConstants.shared.regex.email)
    }
}
