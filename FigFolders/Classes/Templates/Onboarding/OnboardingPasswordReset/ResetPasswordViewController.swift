//
//  NBCResetPasswordViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/13/21.
//

import UIKit

class ResetPasswordViewController: UIViewController {
// MARK: - Outlets
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
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
        
    }
}

// MARK: - TextField Delegate
extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resetPassword()
        return true
    }
}
