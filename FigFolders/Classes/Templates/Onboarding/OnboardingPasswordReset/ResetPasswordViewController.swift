//
//  NBCResetPasswordViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/13/21.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class ResetPasswordViewController: UIViewController {
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
                activityView.stopAnimating()
                activityBackgroundView.removeFromSuperview()
                return
            }
            activityView.stopAnimating()
            activityBackgroundView.removeFromSuperview()
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
