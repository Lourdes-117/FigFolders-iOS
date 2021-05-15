//
//  NBCResetPasswordViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/13/21.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
// MARK: - Outlets
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var emailIdFromLogin: String?
    
    let viewModel = ResetPasswordViewModel()
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }

// MARK: - Initial Setup
    fileprivate func initialSetup() {
        setupViews()
        navigationController?.navigationBar.isHidden = false
    }
    
    fileprivate func setupViews() {
        emailIDTextField.text = emailIdFromLogin
        view.addGradient(from: UIColor.white, to: UIColor.systemGreen, direction: .topToBottom)
        emailIDTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        emailIDTextField.layer.cornerRadius = viewModel.borderRadius
        submitButton.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        submitButton.layer.cornerRadius = viewModel.borderRadius
    }
    
    fileprivate func setupDelegate() {
        emailIDTextField.delegate = self
    }
    
// MARK: - Button Actions
    @IBAction func onTapSubmitButton(_ sender: Any) {
        resetPassword()
    }
    
// MARK: - Helper Methods
    private func resetPassword() {
        let isEmailValid = viewModel.isEmailValid(email: emailIDTextField.text)
        emailIDTextField.addBorder(color: isEmailValid ? viewModel.fieldValidColor : viewModel.fieldInvalidColor, width: viewModel.borderWidth)
        guard isEmailValid else { return }
        FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: emailIDTextField.text ?? "") { error in
            guard error == nil else { return }
            debugPrint("Password Reset Link Sent")
        }
    }
}

// MARK: - TextField Delegate
extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resetPassword()
        return true
    }
}
