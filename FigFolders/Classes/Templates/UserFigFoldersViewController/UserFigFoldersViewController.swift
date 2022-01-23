//
//  UserFigFoldersViewController.swift
//  FigFolders
//
//  Created by Lourdes on 1/23/22.
//

import UIKit

class UserFigFoldersViewController: UIViewController {
// MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    var documentTypeToPopulate: DocumentPickerDocumentType?
    private let viewModel = UserFigFoldersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = documentTypeToPopulate?.rawValue.capitalized
    }
}
