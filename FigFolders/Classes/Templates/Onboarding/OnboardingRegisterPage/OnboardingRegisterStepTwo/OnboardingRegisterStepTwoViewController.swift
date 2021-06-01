//
//  OnboardingRegisterStepTwoViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/13/21.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class OnboardingRegisterStepTwoViewController: UIViewController {
    
// MARK: - Outlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usernameTakenLabel: UILabel!
    @IBOutlet weak var emailIDTakenLabel: UILabel!
    
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
        emailIDTakenLabel.isHidden = true
        view.addGradient(from: UIColor.white, to: UIColor.systemGreen, direction: .topToBottom)
        userNameTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        userNameTextField.layer.cornerRadius = viewModel.borderRadius
        emailIDTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        emailIDTextField.layer.cornerRadius = viewModel.borderRadius
        passwordTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        passwordTextField.layer.cornerRadius = viewModel.borderRadius
        registerButton.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        registerButton.layer.cornerRadius = viewModel.borderRadius
        passwordTextField.setupView()
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
    
    private func isUsernameAvailable(completion: @escaping (Bool) -> Void) {
        guard let username = userNameTextField.text else { return }
        DatabaseManager.shared.isUsernameAvailable(username: username) { [weak self] isUsernameAvailable in
            self?.configureUsernameAvailable(isUsernameAvailable)
            completion(isUsernameAvailable)
        }
    }
    
    private func isEmailIDAvailable(completion: @escaping (Bool) -> Void) {
        guard let emailID = emailIDTextField.text else { return }
        let safeEmail = UserDetailsModel.getSafeEmail(email: emailID)
        DatabaseManager.shared.getUsernameForEmail(emailID: safeEmail) { username in
            let isEmailIDAvailable = username == nil
            self.configureEmailIDAvailable(isEmailIDAvailable)
            completion(isEmailIDAvailable)
        }
    }
    
    private func configureUsernameAvailable(_ isAvailable: Bool) {
        usernameTakenLabel.isHidden = false
        if isAvailable {
            userNameTextField.addBorder(color: viewModel.fieldValidColor, width: viewModel.borderWidth)
            usernameTakenLabel.text = viewModel.usernameAvailable
            usernameTakenLabel.textColor = viewModel.fieldValidColor
        } else {
            userNameTextField.addBorder(color: viewModel.fieldInvalidColor, width: viewModel.borderWidth)
            usernameTakenLabel.text = viewModel.usernameNotAvailable
            usernameTakenLabel.textColor = viewModel.fieldInvalidColor
        }
    }
    
    private func configureEmailIDAvailable(_ isAvailable: Bool) {
        emailIDTakenLabel.isHidden = false
        if isAvailable {
            emailIDTextField.addBorder(color: viewModel.fieldValidColor, width: viewModel.borderWidth)
            emailIDTakenLabel.text = viewModel.emailIDAvailable
            emailIDTakenLabel.textColor = viewModel.fieldValidColor
        } else {
            emailIDTextField.addBorder(color: viewModel.fieldInvalidColor, width: viewModel.borderWidth)
            emailIDTakenLabel.text = viewModel.emailIDNotAvailable
            emailIDTakenLabel.textColor = viewModel.fieldInvalidColor
        }
    }
    
    private func registerUser() {
        view.endEditing(true)
        guard isAllFieldsValid() else { return }
        // Activity Indicator
        let activityBackgroundView = UIView(frame: view.frame)
        activityBackgroundView.backgroundColor = viewModel.activityIndicatorBackgroundColor
        let activityView = NVActivityIndicatorView(frame: CGRect(x: (view.frame.width/2)-50,
                                                                 y: (view.frame.height/2)-50,
                                                                 width: 100,
                                                                 height: 100),
                                                   type: .triangleSkewSpin,
                                                   color: UIColor.blue,
                                                   padding: 0)
        activityBackgroundView.addSubview(activityView)
        activityView.startAnimating()
        view.addSubview(activityBackgroundView)
        
        // Check If Username and EmailID Is Available
        isEmailIDAvailable { [weak self] isEmailIDAvailable in
            guard let strongSelf = self else { return }
            strongSelf.configureEmailIDAvailable(isEmailIDAvailable)
            strongSelf.isUsernameAvailable { [weak self] isUsernameAvailable in
                strongSelf.configureUsernameAvailable(isUsernameAvailable)
                if isUsernameAvailable && isEmailIDAvailable {
                    // Authentication
                    FirebaseAuth.Auth.auth().createUser(withEmail: strongSelf.emailIDTextField.text ?? "", password: strongSelf.passwordTextField.text ?? "") { [weak self] _, error in
                        guard error == nil,
                              let strongSelf = self else {
                            activityView.stopAnimating()
                            activityBackgroundView.removeFromSuperview()
                            return
                        }
                        let userDetails = UserDetailsModel(firstNameString: strongSelf.firstName ?? "",
                                                           lastNameString: strongSelf.lastName ?? "",
                                                           dateOfBirthString: strongSelf.dateOfBirth ?? "",
                                                           phoneNumberString: strongSelf.phoneNumber ?? "",
                                                           emailIDString: strongSelf.emailIDTextField.text ?? "",
                                                           usernameString: strongSelf.userNameTextField.text ?? "",
                                                           profilePicUrlString: "")
                        
                        DatabaseManager.shared.saveUsersData(userDetails: userDetails) { success in
                            if success {
                                FirebaseAuth.Auth.auth().signIn(withEmail: strongSelf.emailIDTextField.text ?? "", password: strongSelf.passwordTextField.text ?? "") { _, error in
                                    guard error == nil else {
                                        activityView.stopAnimating()
                                        activityBackgroundView.removeFromSuperview()
                                        return
                                    }
                                    debugPrint("Created User In Database")
                                    UserDefaults.standard.setValue(strongSelf.firstName, forKey: StringConstants.shared.userDefaults.firstName)
                                    UserDefaults.standard.setValue(strongSelf.lastName, forKey: StringConstants.shared.userDefaults.lastName)
                                    UserDefaults.standard.setValue(UserDetailsModel.getSafeEmail(email:strongSelf.emailIDTextField.text ?? ""), forKey: StringConstants.shared.userDefaults.emailID)
                                    UserDefaults.standard.setValue(strongSelf.phoneNumber, forKey: StringConstants.shared.userDefaults.phoneNumber)
                                    UserDefaults.standard.setValue(strongSelf.dateOfBirth, forKey: StringConstants.shared.userDefaults.dateOfBirth)
                                    UserDefaults.standard.setValue(strongSelf.userNameTextField.text ?? "", forKey: StringConstants.shared.userDefaults.userName)
                                    
                                    activityView.stopAnimating()
                                    activityBackgroundView.removeFromSuperview()
                                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(HomeTabBarController.initiateVC())
                                    debugPrint("Login Successful")
                                }
                                
                                debugPrint("Register Successful")
                            }
                        }
                    }
                } else {
                    activityView.stopAnimating()
                    activityBackgroundView.isHidden = true
                }
            }
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
    
    deinit {
        debugPrint(self.description + "Released From Memory")
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == userNameTextField {
            if !viewModel.isUsernameValid(username: userNameTextField.text) { return }
            isUsernameAvailable { [weak self] isAvailable in
                self?.configureUsernameAvailable(isAvailable)
            }
        } else if textField == emailIDTextField {
            if !viewModel.isEmailValid(email: emailIDTextField.text) { return }
            isEmailIDAvailable { [weak self] isAvailable in
                self?.configureEmailIDAvailable(isAvailable)
            }
        }
    }
}
