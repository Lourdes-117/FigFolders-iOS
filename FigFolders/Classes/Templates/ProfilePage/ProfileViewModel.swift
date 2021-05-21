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
    let editButtonShadowColor = UIColor.lightGray.cgColor
    let editButtonDhadowOpacity: Float = 1
    let editButtonShadowRadius: CGFloat = 10
    let editButtonCornerRadius: CGFloat = 5
    
    let logOutButtonTitle = "Log Out"
    let logOutButtonColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
    
    let saveButtonTitle = "Save"
    let saveButtonColor = UIColor(red: 0, green: 0, blue: 255, alpha: 1)
    let editButtonTitle = "Edit"
    let cancelButtonTitle = "Cancel"
    
    var userDetailToUpdate: UserDetailsModel?
    
    private let logOutConfirmationTitle = "Log Out"
    private let logOutConfirmationMessage = "Are You Sure You Want To Log Out?"
    private let saveConfirmationTitle = "Save"
    private let saveOutConfirmationMessage = "Are You Sure You Want To Update Pesonal Details?"
    let yes = "Yes"
    let no = "No"
    
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
    var fullname: String? {
        return (firstName ?? "") + " " + (lastName ?? "")
    }
    
    let borderWidth: CGFloat = 1
    let borderColor = UIColor.clear
    let inputViewCornerRadius: CGFloat = 5
    
    let fieldValidColor = UIColor.green
    let fieldInvalidColor = UIColor.red
    
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
