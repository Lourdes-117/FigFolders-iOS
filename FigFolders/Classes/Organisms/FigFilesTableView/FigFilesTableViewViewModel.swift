//
//  FigFilesTableViewViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 9/11/21.
//

import Foundation

class FigFilesTableViewViewModel {
    var figFiles: [FigFileModel] = []
    
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
        DatabaseManager.shared.getRandomFigFiles { [weak self] result in
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
