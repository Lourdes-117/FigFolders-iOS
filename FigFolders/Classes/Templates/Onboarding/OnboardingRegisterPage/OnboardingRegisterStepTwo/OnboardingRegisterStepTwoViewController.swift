//
//  OnboardingRegisterStepTwoViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/13/21.
//

import UIKit

class OnboardingRegisterStepTwoViewController: UIViewController {
    
    // MARK: - Outlets
        @IBOutlet weak var userNameTextField: UITextField!
        @IBOutlet weak var emailIDTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
        let viewModel = OnboardingRegisterStepOneViewModel()
        
    // MARK: - Lifecycle Methods
        override func viewDidLoad() {
            super.viewDidLoad()
            initialSetup()
        }
        
        private func initialSetup() {
            navigationController?.navigationBar.isHidden = false
            setupViews()
            setupDelegates()
        }
        
        private func setupViews() {
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
        private func registerUser() {
            
        }
        
    // MARK: - Button Actions
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
