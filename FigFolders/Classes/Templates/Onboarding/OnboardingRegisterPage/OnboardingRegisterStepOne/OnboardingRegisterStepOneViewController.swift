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
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
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
        firstNameTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        firstNameTextField.layer.cornerRadius = viewModel.borderRadius
        lastNameTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        lastNameTextField.layer.cornerRadius = viewModel.borderRadius
        dateOfBirthTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        dateOfBirthTextField.layer.cornerRadius = viewModel.borderRadius
        phoneNumberTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        phoneNumberTextField.layer.cornerRadius = viewModel.borderRadius
        nextButton.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        nextButton.layer.cornerRadius = viewModel.borderRadius
    }
    
    private func setupDelegates() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        dateOfBirthTextField.delegate = self
        phoneNumberTextField.delegate = self
    }
    
//MARK: - Helper Methods
    private func goToStepTwo() {
        guard let registerStepTwoViewController = OnboardingRegisterStepTwoViewController.initiateVC() else { return }
        navigationController?.pushViewController(registerStepTwoViewController, animated: true)
    }
    
// MARK: - Button Actions
    @IBAction func onTapNextButton(_ sender: Any) {
        goToStepTwo()
    }
}

// MARK: - TextField Delegate
extension OnboardingRegisterStepOneViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if firstNameTextField.isFirstResponder {
            lastNameTextField.becomeFirstResponder()
        } else if lastNameTextField.isFirstResponder {
            dateOfBirthTextField.becomeFirstResponder()
        } else if phoneNumberTextField.isFirstResponder {
            phoneNumberTextField.resignFirstResponder()
            goToStepTwo()
        }
        return true
    }
}
