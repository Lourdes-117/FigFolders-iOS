//
//  NBCResetPasswordViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/13/21.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class ResetPasswordViewController: ViewControllerWithLoading {
// MARK: - Outlets
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
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
        view.addGradient(from: viewModel.gradientStartColor, to: viewModel.gradientEndColor, direction: .topToBottom)
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
        
        // Activity Indicator
        showLoadingIndicator()
        
        guard isEmailValid else { return }
        FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: emailIDTextField.text ?? "") { [weak self] error in
            guard error == nil else {
                guard let strongSelf = self else { return }
                switch AuthErrorCode(rawValue: error!._code) {
                case .userNotFound:
                    strongSelf.emailIDTextField.addBorder(color: strongSelf.viewModel.borderColor, width: strongSelf.viewModel.borderWidth)
                    strongSelf.statusLabel.text = strongSelf.viewModel.userNotFound
                    debugPrint("User Not Found")
                default:
                    break
                }
                strongSelf.hideLoadingIndicatorView()
                return
            }
            self?.hideLoadingIndicatorView()
            self?.statusLabel.text = self?.viewModel.passwordResetLinkSent
            debugPrint("Password Reset Link Sent")
        }
    }
    
    deinit {
        debugPrint(self.description + "Released From Memory")
    }
}

// MARK: - TextField Delegate
extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resetPassword()
        return true
    }
}
