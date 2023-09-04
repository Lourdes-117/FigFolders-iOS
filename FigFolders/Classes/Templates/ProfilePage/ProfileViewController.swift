//
//  ProfileViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/18/21.
//

import UIKit
import FirebaseAuth
import SDWebImage
import Charts

class ProfileViewController: ViewControllerWithLoading {

// MARK: - Outlets
    @IBOutlet weak var personalDetailsEditButton: UIButton!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    // Personal Details
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailIDTextField: UITextField!
    @IBOutlet weak var dateOfBirthDatePicker: UIDatePicker!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var changeProfilePhotoButton: UIButton!
    
    let viewModel = ProfileViewModel()

    
// MARK: - Lifecycle Methodss
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupChart()
    }
    
    private func setupChart() {
        self.pieChartView.noDataText = "Loading..."
        viewModel.getStorageUsedByCurrentUser { [weak self] storageModel in
            guard let self = self else { return }
            var dataEntries: [PieChartDataEntry] = []
            let dataEntry1 = PieChartDataEntry(value: Double((storageModel?.maxStorateInMegabytes ?? "0").floatValue - (storageModel?.figFilesStorageUsed ?? "0").floatValue))
            dataEntry1.label = "MB Available"
            dataEntries.append(dataEntry1)
            
            let dataEntry2 = PieChartDataEntry(value: Double((storageModel?.figFilesStorageUsed ?? "0").floatValue))
            dataEntry2.label = "MB Used"
            dataEntries.append(dataEntry2)
            let chartDataSet = PieChartDataSet(entries: dataEntries, label: "")
            chartDataSet.colors = [ColorPalette.primary_green.color ?? .green, .red]
            let chartData = PieChartData(dataSets: [chartDataSet])
            self.pieChartView.animate(xAxisDuration: kAnimationDurationLong, yAxisDuration: kAnimationDurationLong, easingOption: .easeOutBounce)
            self.pieChartView.data = chartData
            self.pieChartView.noDataText = "Error In Loading Data"
        }
    }
    
    private func initialSetup() {
        setupView()
        populateData()
        disableAllInputFields()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardNotifications()
    }
    
    private func setupDelegates() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailIDTextField.delegate = self
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        profilePictureView.layer.borderColor = viewModel.profilePicBorderColor
    }
    
    private func setupView() {
        self.title = viewModel.pageTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: viewModel.navigationTitleColor]
        navigationController?.navigationBar.backgroundColor = viewModel.navigationBarColor
        navigationController?.navigationBar.tintColor = viewModel.navigationTitleColor
        
        firstNameTextField.layer.cornerRadius = viewModel.inputViewCornerRadius
        lastNameTextField.layer.cornerRadius = viewModel.inputViewCornerRadius
        phoneNumberTextField.layer.cornerRadius = viewModel.inputViewCornerRadius
        emailIDTextField.layer.cornerRadius = viewModel.inputViewCornerRadius
        
        setupProfilePicture()
        personalDetailsEditButton.layer.cornerRadius = viewModel.editButtonCornerRadius
        profilePictureView.setRoundedCorners()
        personalDetailsEditButton.layer.shadowColor = viewModel.editButtonShadowColor
        personalDetailsEditButton.layer.shadowOpacity = viewModel.editButtonDhadowOpacity
        personalDetailsEditButton.layer.shadowOffset = .zero
        personalDetailsEditButton.layer.shadowRadius = viewModel.editButtonCornerRadius
        dateOfBirthDatePicker.maximumDate = Date()
        changeProfilePhotoButton.setTitle("", for: .normal)
        changeProfilePhotoButton.setRoundedCorners()
        profilePictureView.layer.borderWidth = viewModel.profildPicBorderWidth
        profilePictureView.layer.borderColor = viewModel.profilePicBorderColor
    }
    
    private func setupProfilePicture() {
        let profilePicTapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapProfilePic))
        profilePictureView.addGestureRecognizer(profilePicTapGesture)
        profilePictureView.isUserInteractionEnabled = true
        if let profilePictureUrl = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.profilePicUrl) as? String,
           let url = URL(string: profilePictureUrl) {
            
            profilePictureView.sd_setImage(with: url, completed: nil)
        }
    }
    
    private func setKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func disableAllInputFields() {
        viewModel.isEditEnabled = false
        
        personalDetailsEditButton.setTitle(viewModel.editButtonTitle, for: .normal)
        
        firstNameTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        lastNameTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        phoneNumberTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        emailIDTextField.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        
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
        
        personalDetailsEditButton.setTitle(viewModel.cancelButtonTitle, for: .normal)
        
        firstNameTextField.isEnabled = true
        lastNameTextField.isEnabled = true
        phoneNumberTextField.isEnabled = true
        emailIDTextField.isEnabled = true
        dateOfBirthDatePicker.isEnabled = true
        
        logoutButton.setTitle(viewModel.saveButtonTitle, for: .normal)
        logoutButton.setTitleColor(viewModel.saveButtonColor, for: .normal)
    }
    
// MARK: - Button Taps
    
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

    @IBAction func onTapChangePassword(_ sender: Any) {
        showLoadingIndicator()
        guard let emailSafe = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.emailID) as? String else {
            hideLoadingIndicatorView()
            return
        }
        let email = UserDetailsModel.getProperEmail(safeEmail: emailSafe)
        FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard error == nil,
                  let strongSelf = self else {
                debugPrint("Error Seting Password Reset Email")
                return
            }
            let alert = UIAlertController(title: strongSelf.viewModel.passwordResetTitle, message: strongSelf.viewModel.passwordResetMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: strongSelf.viewModel.ok, style: .default, handler: nil)
            alert.addAction(action)
            strongSelf.hideLoadingIndicatorView()
            strongSelf.present(alert, animated: true, completion: nil)
        }
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
    
    @IBAction func onTapEditProfilePicButton(_ sender: Any) {
        presentPhotoActionSheet()
    }
    
    @objc func onTapProfilePic() {
        if let profilePictureUrl = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.profilePicUrl) as? String,
           let url = URL(string: profilePictureUrl) {
            guard let profilePicViewerViewController = ImageViewerViewController.initiateVC() else { return }
            profilePicViewerViewController.imageUrl = url
            self.present(profilePicViewerViewController, animated: true)
        }
    }
    
    @IBAction func onTapEditPersonalDetails(_ sender: Any) {
        if viewModel.isEditEnabled {
            disableAllInputFields()
            populateData()
        } else {
            enableAllInputFields()
        }
    }
    
// MARK: - Helper Methods
    private func saveUser(profilePicUrl: String = (UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.profilePicUrl) as? String) ?? "") {
        guard isAllFieldsValid() else { return }
        let safeEmail = UserDetailsModel.getSafeEmail(email: emailIDTextField.text ?? "")
        let userDetails = UserDetailsModel(firstNameString: firstNameTextField.text ?? "",
                                           lastNameString: lastNameTextField.text ?? "",
                                           dateOfBirthString: dateOfBirthDatePicker.date.toDateString(),
                                           phoneNumberString: phoneNumberTextField.text ?? "",
                                           emailIDString: safeEmail,
                                           usernameString: viewModel.userName ?? "",
                                           profilePicUrlString: profilePicUrl)
        showLoadingIndicator()
        guard let _ = currentUserUsername else {
            self.hideLoadingIndicatorView()
            return
        }
            // Use Email Available. Can be updated in Firebase Auth
            if self.viewModel.emailID == self.emailIDTextField.text { // Email ID Not changed
                DatabaseManager.shared.updateDetailsOfUser(userDetails: userDetails) { [weak self] success in
                    guard let strongSelf = self else { return }
                    strongSelf.hideLoadingIndicatorView()
                    if success {
                        UserDefaults.standard.setValue(userDetails.firstName, forKey: StringConstants.shared.userDefaults.firstName)
                        UserDefaults.standard.setValue(userDetails.lastName, forKey: StringConstants.shared.userDefaults.lastName)
                        UserDefaults.standard.setValue(userDetails.safeEmail, forKey: StringConstants.shared.userDefaults.emailID)
                        UserDefaults.standard.setValue(userDetails.phoneNumber, forKey: StringConstants.shared.userDefaults.phoneNumber)
                        UserDefaults.standard.setValue(userDetails.dateOfBirth, forKey: StringConstants.shared.userDefaults.dateOfBirth)
                        self?.populateData()
                    }
                }
            } else { // Email ID Changed
                self.viewModel.userDetailToUpdate = userDetails
                if let loginViewController = LoginViewController.initiateVC() {
                    loginViewController.delegate = self
                    loginViewController.shouldActAsVerificationScreen = true
                    self.present(loginViewController, animated: true, completion: nil)
                }
            }
        disableAllInputFields()
    }
    
    private func isAllFieldsValid() -> Bool {
        let isEmailValid = viewModel.isEmailValid(email: emailIDTextField.text)
        emailIDTextField.addBorder(color: isEmailValid ? viewModel.fieldValidColor : viewModel.fieldInvalidColor, width: viewModel.borderWidth)
        let isFirstNameValid = viewModel.isValidName(name: firstNameTextField.text)
        firstNameTextField.addBorder(color: isFirstNameValid ? viewModel.fieldValidColor : viewModel.fieldInvalidColor, width: viewModel.borderWidth)
        let isLastNameValid = viewModel.isValidName(name: lastNameTextField.text)
        lastNameTextField.addBorder(color: isLastNameValid ? viewModel.fieldValidColor : viewModel.fieldInvalidColor, width: viewModel.borderWidth)
        let isPhoneNumberValid = viewModel.isValidPhoneNumber(number: phoneNumberTextField.text)
        phoneNumberTextField.addBorder(color: isPhoneNumberValid ? viewModel.fieldValidColor : viewModel.fieldInvalidColor, width: viewModel.borderWidth)
        
        return isEmailValid && isFirstNameValid && isLastNameValid && isPhoneNumberValid
    }
    
    private func signoutUser() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            deleteAllUserDefaults()
            let storyboard = UIStoryboard(name: String(describing: OnboardingViewController.self), bundle: Bundle.main)
            let viewController = storyboard.instantiateViewController(identifier: String(describing: OnboardingViewController.self))
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        } catch {
            debugPrint("Error In Signing Out User")
        }
    }
    
    deinit {
        debugPrint(self.description + "Released From Memory")
    }
}


// MARK: - User Verification Delegate
extension ProfileViewController: UserVerificationDelegate {
    func verificationSuccessful() {
        FirebaseAuth.Auth.auth().currentUser?.updateEmail(to: emailIDTextField.text ?? "") { [weak self] error in
            guard error == nil else {
                self?.hideLoadingIndicatorView()
                debugPrint("Email Update Failed In Firebase Auth")
                return
            }
            guard let strongSelf = self,
                  let userDetails = strongSelf.viewModel.userDetailToUpdate else {
                self?.hideLoadingIndicatorView()
                debugPrint("Error Updating Values To Database")
                return
            }
            strongSelf.viewModel.userDetailToUpdate = nil
            DatabaseManager.shared.updateDetailsOfUser(userDetails: userDetails) { success in
                strongSelf.hideLoadingIndicatorView()
                if success {
                    UserDefaults.standard.setValue(userDetails.firstName, forKey: StringConstants.shared.userDefaults.firstName)
                    UserDefaults.standard.setValue(userDetails.lastName, forKey: StringConstants.shared.userDefaults.lastName)
                    UserDefaults.standard.setValue(userDetails.safeEmail, forKey: StringConstants.shared.userDefaults.emailID)
                    UserDefaults.standard.setValue(userDetails.phoneNumber, forKey: StringConstants.shared.userDefaults.phoneNumber)
                    UserDefaults.standard.setValue(userDetails.safeEmail, forKey: StringConstants.shared.userDefaults.emailID)
                    UserDefaults.standard.setValue(userDetails.dateOfBirth, forKey: StringConstants.shared.userDefaults.dateOfBirth)
                    self?.populateData()
                    self?.disableAllInputFields()
                }
            }
        }
    }
    
    func verificationFailed() {
        // TODO: - Handle Failure Notification
        hideLoadingIndicatorView()
        enableAllInputFields()
        viewModel.userDetailToUpdate = nil
    }
}


// MARK: - TextField Delegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

// MARK: - Image Picker
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: viewModel.profilePicSelectionTitle, message: viewModel.profilePicSelectionMessage, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: viewModel.cancel, style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: viewModel.takePhoto, style: .default, handler: {[weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: viewModel.selectPhoto, style: .default, handler: {[weak self] _ in
            self?.presentPhotoPicker()
        }))
        if let _ = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.profilePicUrl) { // Show delete button only if image already available
            actionSheet.addAction(UIAlertAction(title: viewModel.deleteProfilePic, style: .destructive, handler: {[weak self] _ in
                self?.removeProfilePicture()
            }))
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func presentPhotoPicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func removeProfilePicture() {
        DatabaseManager.shared.removeProfilePicUrlForCurrentUser()
        StorageManager.shared.removeProfilePicForCurrentUser()
        profilePictureView.image = UIImage(systemName: viewModel.profilePicDefaultImageName)
        // Remove from url from user defaults and image from cache
        guard let profilePictureUrl = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.profilePicUrl) as? String else { return }
        SDImageCache.shared.removeImage(forKey: profilePictureUrl, withCompletion: nil )
        UserDefaults.standard.removeObject(forKey: StringConstants.shared.userDefaults.profilePicUrl)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let username = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.userName) as? String,
                  let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
                picker.dismiss(animated: true, completion: nil)
                return
            }
        showLoadingIndicator()
        StorageManager.shared.uploadProfilePicture(username: username, image: image) { [weak self] result in
            self?.hideLoadingIndicatorView()
            switch result {
            case .success(let url):
                UserDefaults.standard.setValue(url, forKey: StringConstants.shared.userDefaults.profilePicUrl)
                self?.profilePictureView.image = image
                self?.saveUser(profilePicUrl: url)
            case .failure(let error):
                debugPrint("Error Uploadding Profile Picture: ",error)
                break;
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

