//
//  LoginViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/11/21.
//

import UIKit

class LoginViewController: UIViewController {
// MARK: - Outlets
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    
    let viewModel = LoginViewModel()
    
// MARK: - Lifecycle And Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupDelegate()
    }
    
    fileprivate func initialSetup() {
        setupView()
        navigationController?.navigationBar.isHidden = false
    }
    
    fileprivate func setupView() {
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
        navigationController?.pushViewController(resetViewController, animated: true)
    }
    
    
// MARK: - Helper Methods
    
    fileprivate func authenticateUser(email: String?, password: String?) {
        guard let email = email,
              let password = password else { return }
        debugPrint("Handle Login")
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
