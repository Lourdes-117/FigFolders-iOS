//
//  ProfileViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 5/18/21.
//

import UIKit

class ProfileViewModel {
    var isEditEnabled = false
    
    let pageTitle = "My Profile"
    let editButtonShadowColor = ColorPalette.greyscale3.color?.cgColor
    let editButtonDhadowOpacity: Float = 1
    let editButtonShadowRadius: CGFloat = 10
    let editButtonCornerRadius: CGFloat = 5
    
    let logOutButtonTitle = "Log Out"
    let logOutButtonColor = LabelColorPalette.labelColorRed.color
    
    let saveButtonTitle = "Save"
    let saveButtonColor = LabelColorPalette.labelColorLink.color
    let editButtonTitle = "Edit"
    let cancelButtonTitle = "Cancel"
    
    var userDetailToUpdate: UserDetailsModel?
    
    private let logOutConfirmationTitle = "Log Out"
    private let logOutConfirmationMessage = "Are You Sure You Want To Log Out?"
    private let saveConfirmationTitle = "Save"
    private let saveOutConfirmationMessage = "Are You Sure You Want To Update Pesonal Details?"
    let passwordResetTitle = "Password Reset"
    let passwordResetMessage = "Password Reset Email Sent. Please Check Your Email"
    let ok = "Okay"
    let yes = "Yes"
    let no = "No"
    
    let profilePicSelectionTitle = "Profile Picture"
    let profilePicSelectionMessage = "How Would You Like To Select Your Picture"
    let cancel = "Cancel"
    let takePhoto = "Take Photo"
    let choosePhoto = "Choose Photo"
    
    var alertTitle: String {
        isEditEnabled ? saveConfirmationTitle: logOutConfirmationTitle
    }
    var alertMessage: String {
        isEditEnabled ? saveOutConfirmationMessage: logOutConfirmationMessage
    }
    
    var firstName: String? {
        UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.firstName) as? String
    }
    
    var lastName: String? {
        UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.lastName) as? String
    }
    
    var userName: String? {
        UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.userName) as? String
    }
    
    var profilePicUrl: String? {
        UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.profilePicUrl) as? String
    }
    
    var dateOfBirth: Date {
        guard let dateString = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.dateOfBirth) as? String else { return Date() }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDateFormatMMddyyyy
        let dateObject = dateFormatter.date(from: dateString)
        return dateObject ?? Date()
    }
    var phoneNumber: String? {
        UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.phoneNumber) as? String
    }
    var emailID: String {
        let safeEmail = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.emailID) as? String
        return UserDetailsModel.getProperEmail(safeEmail: safeEmail ?? "")
    }
    var safeEmail: String? {
        return UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.emailID) as? String
    }
    var fullname: String? {
        return (firstName ?? "") + " " + (lastName ?? "")
    }
    
    let borderWidth: CGFloat = 1
    let borderColor = UIColor.clear
    let inputViewCornerRadius: CGFloat = 5
    let navigationTitleColor = LabelColorPalette.labelColorPrimary.color ?? UIColor()
    let navigationBarColor = ColorPalette.primary_green.color
    
    let fieldValidColor = UIColor.green
    let fieldInvalidColor = LabelColorPalette.labelColorRed.color ?? UIColor()
    
    func isEmailValid(email: String?) -> Bool {
        guard let email = email,
              !email.isEmpty else { return false }
        return email.matchesRegex(StringConstants.shared.regex.email)
    }
    
    func isValidName(name: String?) -> Bool {
        guard let name = name else { return false }
        return name.matchesRegex(StringConstants.shared.regex.name)
    }
    
    func isValidPhoneNumber(number: String?) -> Bool {
        guard let number = number else { return false }
        return number.matchesRegex(StringConstants.shared.regex.phoneNumber)
    }
}
