//
//  UserProfileViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 9/13/21.
//

import UIKit

class UserProfileViewModel {
    var userNameToPopulate: String?
    let numberOfSections: Int = 2
    var figFiles: [FigFileModel?]?
    
    func getNumberOfRows(section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return figFiles?.count ?? 0
        }
    }
    
    func getCellForSection(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailsTableViewCell.kCellId) as? UserDetailsTableViewCell else { return UITableViewCell() }
            cell.setupCell(userName: userNameToPopulate ?? "")
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FigFilesTableViewCell.kCellId) as? FigFilesTableViewCell,
                  indexPath.row < figFiles?.count ?? 0,
                  let figFile = figFiles?[indexPath.row] else { return UITableViewCell() }
            cell.setupCell(figFile: figFile, indexPath: indexPath)
            return cell
        }
    }
}
