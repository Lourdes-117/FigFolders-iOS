//
//  ProfileViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/18/21.
//

import UIKit
import FirebaseAuth

class ProfileViewController: ViewControllerWithLoading {

// MARK: - Outlets
    @IBOutlet weak var personalDetailsEditButton: UIButton!
    @IBOutlet weak var profilePictureView: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // Personal Details
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var dateOfBirthDatePicker: UIDatePicker!
    @IBOutlet weak var logoutButton: UIButton!
    
    let viewModel = ProfileViewModel()
    
// MARK: - Lifecycle Methodss
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        setupView()
        populateData()
        disableAllInputFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        self.title = viewModel.pageTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        personalDetailsEditButton.layer.cornerRadius = viewModel.editButtonCornerRadius
        profilePictureView.setRoundedCorners()
        personalDetailsEditButton.layer.shadowColor = viewModel.editButtonShadowColor
        personalDetailsEditButton.layer.shadowOpacity = viewModel.editButtonDhadowOpacity
        personalDetailsEditButton.layer.shadowOffset = .zero
        personalDetailsEditButton.layer.shadowRadius = viewModel.editButtonCornerRadius
        dateOfBirthDatePicker.maximumDate = Date()
    }
    
    func disableAllInputFields() {
        viewModel.isEditEnabled = false
        
        personalDetailsEditButton.isHidden = false
        
        firstNameTextField.isEnabled = false
        lastNameTextField.isEnabled = false
        phoneNumberTextField.isEnabled = false
        emailIDTextField.isEnabled = false
        dateOfBirthDatePicker.isEnabled = false
        
        logoutButton.setTitle(viewModel.logOutButtonTitle, for: .normal)
        logoutButton.setTitleColor(viewModel.logOutButtonColor, for: .normal)
    }
    
    private func populateData() {
        fullNameLabel.text = viewModel.fullname
        usernameLabel.text = viewModel.userName
        firstNameTextField.text = viewModel.firstName
        lastNameTextField.text = viewModel.lastName
        phoneNumberTextField.text = viewModel.phoneNumber
        emailIDTextField.text = viewModel.emailID
        dateOfBirthDatePicker.date = viewModel.dateOfBirth
    }
    
    func enableAllInputFields() {
        viewModel.isEditEnabled = true
        
        personalDetailsEditButton.isHidden = true
        
        firstNameTextField.isEnabled = true
        lastNameTextField.isEnabled = true
        phoneNumberTextField.isEnabled = true
        emailIDTextField.isEnabled = true
        dateOfBirthDatePicker.isEnabled = true
        
        logoutButton.setTitle(viewModel.saveButtonTitle, for: .normal)
        logoutButton.setTitleColor(viewModel.saveButtonColor, for: .normal)
    }
    
// MARK: - Button Taps
    @IBAction func onTapChangePassword(_ sender: Any) {
    }
    
    @IBAction func onTapLogOutButton(_ sender: Any) {
        
        let alertView = UIAlertController(title: viewModel.alertTitle, message: viewModel.alertMessage, preferredStyle: .alert)
        let noAction = UIAlertAction(title: viewModel.no, style: .default) { [weak self] _ in
            if !(self?.viewModel.isEditEnabled ?? false) { return }
            self?.disableAllInputFields()
            self?.populateData()
        }
        let yesAction = UIAlertAction(title: viewModel.yes, style: .destructive) { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.viewModel.isEditEnabled ? strongSelf.saveUser(): strongSelf.signoutUser()
        }
        alertView.addAction(noAction)
        alertView.addAction(yesAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func onTapEditPersonalDetails(_ sender: Any) {
        enableAllInputFields()
    }
    
    deinit {
        debugPrint(self.description + "Released From Memory")
    }
    
// MARK: - Helper Methods
    private func saveUser() {
        disableAllInputFields()
        populateData()
    }
    
    private func signoutUser() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            let storyboard = UIStoryboard(name: String(describing: OnboardingViewController.self), bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(identifier: String(describing: OnboardingViewController.self))
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        } catch {
            debugPrint("Error In Signing Out User")
        }
    }
}
