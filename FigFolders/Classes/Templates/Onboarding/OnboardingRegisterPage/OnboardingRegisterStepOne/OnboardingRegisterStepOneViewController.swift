//
//  OnboardingRegisterStepOneViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/13/21.
//

import UIKit

class OnboardingRegisterStepOneViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var datePicker: UIDatePicker!

    let viewModel = OnboardingRegisterStepOneViewModel()
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }
    
    private func initialSetup() {
        navigationController?.navigationBar.isHidden = false
        setupViews()
        view.addGradient(from: viewModel.gradientStartColor, to: viewModel.gradientEndColor, direction: .topToBottom)
        setupDelegates()
    }
    
    private func setKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupViews() {
        datePicker.maximumDate = Date()
        firstNameTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        datePicker.layer.cornerRadius = viewModel.borderRadius
        firstNameTextField.layer.cornerRadius = viewModel.borderRadius
        lastNameTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        lastNameTextField.layer.cornerRadius = viewModel.borderRadius
        phoneNumberTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        phoneNumberTextField.layer.cornerRadius = viewModel.borderRadius
        nextButton.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        nextButton.layer.cornerRadius = viewModel.borderRadius
    }
    
    private func setupDelegates() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneNumberTextField.delegate = self
    }
    
//MARK: - Helper Methods
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    private func validateFields() -> Bool {
        let isFirstNameValid = viewModel.isValidName(name: firstNameTextField.text)
        firstNameTextField.addBorder(color: isFirstNameValid ? viewModel.fieldValidColor : viewModel.fieldInvalidColor, width: viewModel.borderWidth)
        let isLastNameValid = viewModel.isValidName(name: lastNameTextField.text)
        lastNameTextField.addBorder(color: isLastNameValid ? viewModel.fieldValidColor : viewModel.fieldInvalidColor, width: viewModel.borderWidth)
        let isPhoneNumberValid = viewModel.isValidPhoneNumber(number: phoneNumberTextField.text)
        phoneNumberTextField.addBorder(color: isPhoneNumberValid ? viewModel.fieldValidColor : viewModel.fieldInvalidColor, width: viewModel.borderWidth)
        
        return isFirstNameValid && isLastNameValid && isPhoneNumberValid
    }
    
    private func goToStepTwo() {
        guard validateFields() else { return }
        guard let registerStepTwoViewController = OnboardingRegisterStepTwoViewController.initiateVC() else { return }
        registerStepTwoViewController.firstName = firstNameTextField.text
        registerStepTwoViewController.lastName = lastNameTextField.text
        registerStepTwoViewController.dateOfBirth = datePicker.date.toDateString()
        registerStepTwoViewController.phoneNumber = phoneNumberTextField.text
        navigationController?.pushViewController(registerStepTwoViewController, animated: true)
    }
    
// MARK: - Button Actions
    @IBAction func onTapNextButton(_ sender: Any) {
        goToStepTwo()
    }
    
    deinit {
        debugPrint(self.description + "Released From Memory")
    }
}

// MARK: - TextField Delegate
extension OnboardingRegisterStepOneViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if firstNameTextField.isFirstResponder {
            lastNameTextField.becomeFirstResponder()
        } else if lastNameTextField.isFirstResponder {
            lastNameTextField.resignFirstResponder()
        } else if phoneNumberTextField.isFirstResponder {
            phoneNumberTextField.resignFirstResponder()
            goToStepTwo()
        }
        return true
    }
}
