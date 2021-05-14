//
//  ViewController.swift
//  FigFolders
//
//  Created by Lourdes on 5/10/21.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var onboardingCollectionView: OnboardingCollectionView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    let viewModel = OnboardingViewModel()
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
// MARK: - Setup
    private func initialSetup() {
        setupViews()
        setupDatasourceDelegate()
    }
    
    private func setupViews() {
        loginButton.addBorder(color: viewModel.borderColor, width: viewModel.borderWidth)
        loginButton.layer.cornerRadius = viewModel.borderRadius
        signupButton.layer.cornerRadius = viewModel.borderRadius
    }
    
    private func setupDatasourceDelegate() {
        onboardingCollectionView.delegate = self
    }
    
// MARK: - Button Actions
    @IBAction func onTapLogin(_ sender: Any) {
        guard let loginViewController = LoginViewController.initiateVC() else { return }
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @IBAction func onTapSignup(_ sender: Any) {
        guard let signupViewController = OnboardingRegisterStepOneViewController.initiateVC() else { return }
        navigationController?.pushViewController(signupViewController, animated: true)
    }
}

// MARK: - Delegates
extension OnboardingViewController: OnboardingCollectionViewDelegate {
    func didFinishOnboarding() {
        onboardingCollectionView.fadeOut()
    }
}
