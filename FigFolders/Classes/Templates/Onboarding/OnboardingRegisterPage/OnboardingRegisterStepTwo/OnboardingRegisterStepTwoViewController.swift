//
//  OnboardingRegisterStepTwoViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/13/21.
//

import UIKit
import FirebaseAuth

class OnboardingRegisterStepTwoViewController: UIViewController {
    
// MARK: - Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTakenLabel: UILabel!
    
    let viewModel = OnboardingRegisterStepTwoViewModel()
    
// MARK: - Data From Step One
    var firstName: String?
    var lastName: String?
    var dateOfBirth: String?
    var phoneNumber: String?
    
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
        usernameTakenLabel.isHidden = true
        view.addGradient(from: UIColor.white, to: UIColor.systemGreen, direction: .topToBottom)
        userNameTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        userNameTextField.layer.cornerRadius = viewModel.borderRadius
        emailIDTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        emailIDTextField.layer.cornerRadius = viewModel.borderRadius
        passwordTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        passwordTextField.layer.cornerRadius = viewModel.borderRadius
        registerButton.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        registerButton.layer.cornerRadius = viewModel.borderRadius
    }
    
    private func setupDelegates() {
        userNameTextField.delegate = self
        emailIDTextField.delegate = self
        emailIDTextField.delegate = self
    }
    
//MARK: - Helper Methods
    private func isAllFieldsValid() -> Bool {
        let isEmailValid = viewModel.isEmailValid(email: emailIDTextField.text)
        emailIDTextField.addBorder(color: isEmailValid ? viewModel.fieldValidColor : viewModel.fieldInvalidColor, width: viewModel.borderWidth)
        let isUsernameValid = viewModel.isUsernameValid(username: userNameTextField.text)
        userNameTextField.addBorder(color: isUsernameValid ? viewModel.fieldValidColor : viewModel.fieldInvalidColor, width: viewModel.borderWidth)
        let isPasswordValid = viewModel.isPasswordValid(password: passwordTextField.text)
        passwordTextField.addBorder(color: isPasswordValid ? viewModel.fieldValidColor : viewModel.fieldInvalidColor, width: viewModel.borderWidth)
        
        return isEmailValid && isUsernameValid && isPasswordValid
    }
    
    private func registerUser() {
        guard isAllFieldsValid() else { return }
        FirebaseAuth.Auth.auth().createUser(withEmail: emailIDTextField.text ?? "", password: passwordTextField.text ?? "") { _, error in
            guard error == nil else { return }
            debugPrint("Register User")
        }
    }
    
// MARK: - Button Actions
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
    
    @IBAction func onTapRegisterButton(_ sender: Any) {
        registerUser()
    }
}

// MARK: - TextField Delegate
extension OnboardingRegisterStepTwoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if userNameTextField.isFirstResponder {
            emailIDTextField.becomeFirstResponder()
        } else if emailIDTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
            registerUser()
        }
        return true
    }
}
