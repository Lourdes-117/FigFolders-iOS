//
//  ArrayUtility.swift
//  FigFolders
//
//  Created by Lourdes on 9/14/21.
//

import Foundation
extension Array {
    
    mutating func appendSafely(_ newElement: Element?) {
        guard let element = newElement else {
            return
        }
        
        self.append(element)
    }
    
    func getObjectSafely(_ index: Int) -> Element? {
        guard index < self.count else {
            return nil
        }
        return self[index]
    }
}

// MARK: Remove Duplicates from Array

extension Array where Element: Hashable {
    
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
