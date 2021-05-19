//
//  ProfileViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/18/21.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var personalDetailsEditButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var profilePictureView: UIImageView!
    
    // Personal Details
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var dateOfBirthDatePicker: UIDatePicker!
    
    let viewModel = ProfileViewModel()
    
// MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        setupView()
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
    
// MARK: - Button Taps
    @IBAction func onTapChangePassword(_ sender: Any) {
    }
    
    @IBAction func onTapLogOutButton(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            debugPrint("Error In Signing Out User")
        }
    }
    
    @IBAction func onTapEditPersonalDetails(_ sender: Any) {
    }
}
