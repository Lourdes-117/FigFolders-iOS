//
//  LoginViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/11/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
// MARK: - Outlets
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let viewModel = LoginViewModel()
    
// MARK: - Lifecycle And Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setKeyboardNotifications()
        resetView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }
    
    fileprivate func resetView() {
        passwordTextField.text = nil
        setupView()
    }
    
    private func setKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func initialSetup() {
        setupView()
        navigationController?.navigationBar.isHidden = false
    }
    
    fileprivate func setupView() {
        view.addGradient(from: UIColor.white, to: UIColor.systemGreen, direction: .topToBottom)
        emailIDTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        emailIDTextField.layer.cornerRadius = viewModel.borderRadius
        passwordTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        passwordTextField.layer.cornerRadius = viewModel.borderRadius
        signinButton.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        signinButton.layer.cornerRadius = viewModel.borderRadius
    }
    
    fileprivate func setupDelegate() {
        emailIDTextField.delegate = self
        passwordTextField.delegate = self
    }
    
// MARK: - Button Actions
    @IBAction func onTapSignInButton(_ sender: Any) {
        authenticateUser(email: emailIDTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func onTapForgotPassword(_ sender: Any) {
        guard let resetViewController = ResetPasswordViewController.initiateVC() else { return }
        if viewModel.isEmailValid(email: emailIDTextField.text) {
            resetViewController.emailIdFromLogin = emailIDTextField.text
        }
        navigationController?.pushViewController(resetViewController, animated: true)
    }
    
    
// MARK: - Helper Methods
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
    
    fileprivate func validateInputs() -> Bool {
        let isEmailValid = viewModel.isEmailValid(email: emailIDTextField.text)
        let isPasswordValid = viewModel.isPasswordValid(password: passwordTextField.text)
        
        emailIDTextField.addBorder(color: isEmailValid ? viewModel.fieldValidColor : viewModel.fieldInvalidColor, width: 2)
        passwordTextField.addBorder(color: isPasswordValid ? viewModel.fieldValidColor : viewModel.fieldInvalidColor, width: 2)
        return isEmailValid && isPasswordValid
    }
    
    fileprivate func authenticateUser(email: String?, password: String?) {
        guard validateInputs() else { return }
        FirebaseAuth.Auth.auth().signIn(withEmail: emailIDTextField.text ?? "", password: passwordTextField.text ?? "") { _, error in
            guard error == nil else { return }
            debugPrint("Signin Successful")
        }
    }
}

// MARK: - TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailIDTextField.isFirstResponder {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField.isFirstResponder {
            authenticateUser(email: emailIDTextField.text, password: passwordTextField.text)
            view.endEditing(true)
        }
        return true
    }
}
