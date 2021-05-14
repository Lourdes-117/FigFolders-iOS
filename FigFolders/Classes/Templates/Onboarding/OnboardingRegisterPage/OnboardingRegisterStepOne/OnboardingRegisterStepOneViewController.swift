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
        view.addGradient(from: UIColor.white, to: UIColor.systemGreen, direction: .topToBottom)
        firstNameTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        firstNameTextField.layer.cornerRadius = viewModel.borderRadius
        lastNameTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        lastNameTextField.layer.cornerRadius = viewModel.borderRadius
        dateOfBirthTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        dateOfBirthTextField.layer.cornerRadius = viewModel.borderRadius
        dateOfBirthTextField.inputView = datePicker
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
            lastNameTextField.resignFirstResponder()
        } else if phoneNumberTextField.isFirstResponder {
            phoneNumberTextField.resignFirstResponder()
            goToStepTwo()
        }
        return true
    }
}
