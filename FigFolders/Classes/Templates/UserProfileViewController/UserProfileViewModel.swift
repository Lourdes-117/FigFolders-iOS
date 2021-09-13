//
//  UserProfileViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 9/13/21.
//

import UIKit

class UserProfileViewModel {
    var paginationIndex = 0
    var userNameToPopulate: String?
    let numberOfSections: Int = 2
    var figFiles: [FigFileModel?] = []
    
    func getNumberOfRows(section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return numberOfFigFiles
        }
    }
    
    var numberOfFigFiles: Int {
        figFiles.count
    }
    
    func getIndexPathBetweenNumbers(numberOfItemsBeforeUpdate: Int, numberOfItemsAfterUpdate: Int) -> [IndexPath] {
        var indexPathArray: [IndexPath] = []
        for index in numberOfItemsBeforeUpdate...(numberOfItemsAfterUpdate - 1) {
            indexPathArray.append(IndexPath(row: index, section: 1))
        }
        return indexPathArray
    }
    
    func getCellForSection(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserDetailsTableViewCell.kCellId) as? UserDetailsTableViewCell else { return UITableViewCell() }
            cell.setupCell(userName: userNameToPopulate ?? "")
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FigFilesTableViewCell.kCellId) as? FigFilesTableViewCell,
                  indexPath.row < numberOfFigFiles,
                  let figFile = figFiles[indexPath.row] else { return UITableViewCell() }
            cell.setupCell(figFile: figFile, indexPath: indexPath)
            return cell
        }
    }
    
    func fetchFigFilesWithPagination(completion: @escaping (_ numberOfNewFiles: Int) -> Void) {
        DatabaseManager.shared.getFigFilesOfUser(username: userNameToPopulate ?? "", paginationIndex: paginationIndex) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let fetchedFigFiles):
                strongSelf.figFiles.append(contentsOf: fetchedFigFiles)
                completion(fetchedFigFiles.count)
            case .failure(let error):
                debugPrint("Error Fetching Random FigFiles \(error)")
            }
        }
    }
}
