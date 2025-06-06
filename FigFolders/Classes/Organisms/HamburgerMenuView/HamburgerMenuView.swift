//
//  HamburgerMenuView.swift
//  FigFolders
//
//  Created by Lourdes on 5/17/21.
//

import UIKit

class HamburgerMenuView: UIView {
// MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewProfileButton: UIButton!
    
    let kIdentifier = "HamburgerMenuView"
    let viewModel = HamburgerMenuViewModel()
    
    weak var delegate: HamburgerMenuDelegate?
    
// MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
        setupView()
        registerCells()
        setupDatasourceDelegte()
    }
    
    private func initialSetup() {
        commonInit(kIdentifier)
    }
    
    func refreshView() {
        setupView()
    }
    
    private func setupView() {
        profilePictureImage.layer.cornerRadius = profilePictureImage.frame.height/2
        viewProfileButton.setTitle(viewModel.viewProfileButtonTitle, for: .normal)
        nameLabel.text = viewModel.fullName
        setupProfilePic()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapViewProfileButton(_:)))
        profilePictureImage.isUserInteractionEnabled = true
        profilePictureImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func expandOrCollapseMenu() {
        setupProfilePic()
    }
    
    private func setupProfilePic() {
        if let profilePictureUrl = UserDefaults.standard.value(forKey: StringConstants.shared.userDefaults.profilePicUrl) as? String,
           let url = URL(string: profilePictureUrl) {
            
            profilePictureImage.sd_setImage(with: url, completed: nil)
        } else {
            profilePictureImage.image = UIImage(systemName: viewModel.profilePicDefaultImageName)
        }
    }
    
    private func registerCells() {
        let hamburgerMenuCell = UINib(nibName: HamburgermenuTableViewCell.kIdentifier, bundle: Bundle.main)
        tableView.register(hamburgerMenuCell, forCellReuseIdentifier: HamburgermenuTableViewCell.kIdentifier)
    }
    
    private func setupDatasourceDelegte() {
        tableView.dataSource = self
        tableView.delegate = self
    }

// MARK: - Button Actions
    @IBAction @objc func onTapViewProfileButton(_ sender: Any) {
        delegate?.onTapViewProfile()
    }
    
    @IBAction func onTapHelpButton(_ sender: Any) {
    }
}

// MARK: - TableView Datasource
extension HamburgerMenuView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HamburgerMenuItemType.none.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HamburgermenuTableViewCell.kIdentifier) as? HamburgermenuTableViewCell else { return UITableViewCell() }
        cell.setupCell(type: HamburgerMenuItemType(rawValue: indexPath.row) ?? .myFiles)
        return cell
    }
}

extension HamburgerMenuView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = HamburgerMenuItemType(rawValue: indexPath.row) else { return }
        delegate?.onSelectHamburgerMenu(type: type)
    }
}
