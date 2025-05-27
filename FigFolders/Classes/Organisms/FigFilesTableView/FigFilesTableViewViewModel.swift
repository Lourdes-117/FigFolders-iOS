//
//  FigFilesTableViewViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 9/11/21.
//

import Foundation

enum FigFilesTableViewBehaviour {
    case homePage
    case figFilesPage
}

class FigFilesTableViewViewModel {
    var documentTypeToPopulate: DocumentPickerDocumentType?
    var figFilesTableViewBehaviour: FigFilesTableViewBehaviour = .homePage
    var figFiles: [FigFileModel] = []
    var paginationIndex = 1
    
    var numberOfFiles: Int {
        figFiles.count
    }
    
    func getIndexPathBetweenNumbers(numberOfItemsBeforeUpdate: Int, numberOfItemsAfterUpdate: Int) -> [IndexPath] {
        var indexPathArray: [IndexPath] = []
        for index in numberOfItemsBeforeUpdate...(numberOfItemsAfterUpdate-1) {
            indexPathArray.append(IndexPath(row: index, section: 0))
        }
        return indexPathArray
    }
    
    func fetchRandomFigFiles(completion: @escaping (_ numberOfNewCells: Int) -> Void) {
        switch figFilesTableViewBehaviour {
        case .homePage:
            CloudFunctionsManager.shared.getRandomFigFiles { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let fetchedFigFiles):
                    strongSelf.figFiles.append(contentsOf: fetchedFigFiles)
                    completion(fetchedFigFiles.count)
                case .failure(let error):
                    completion(0)
                    debugPrint("Error Fetching User's FigFiles \(error)")
                }
            }
        case .figFilesPage:
            let currentUser = currentUserUsername ?? ""
            CloudFunctionsManager.shared.getUserFigFilesWithType(userName: currentUser, paginationIndex: paginationIndex, documentType: documentTypeToPopulate ?? .image) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let fetchedFigFiles):
                    strongSelf.figFiles.append(contentsOf: fetchedFigFiles)
                    completion(fetchedFigFiles.count)
                case .failure(let error):
                    completion(0)
                    debugPrint("Error Fetching User's FigFiles \(error)")
                }
            }
            paginationIndex += 1
        }
    }
}
