//
//  SearchControllerViewModel.swift
//  FigFolders
//
//  Created by Lourdes Dinesh on 5/24/22.
//

import Foundation

class SearchControllerViewModel {
    let pageTitle = "Search"
    let enterSearchTermString = "Enter Search Term To Continue"
    let noResultsFoundString = "No Results Found"
    
    var pagination = 0
    var queryString = ""
    var searchResultUserNames: [String] = []
    
    private var lastTimeToSearchRegistered = Date()
    var shouldInturruptSearch: Bool {
        get {
            return lastTimeToSearchRegistered.timeIntervalSinceNow <= -1 ? false : true
        }
        set {
            if newValue {
                lastTimeToSearchRegistered = Date()
            } else {
                lastTimeToSearchRegistered.addTimeInterval(-1)
            }
        }
    }

    
    func searchUserNames(queryUserName: String, completion: @escaping (Bool) -> Void) {
        CloudFunctionsManager.shared.searchUsers(queryUserName: queryUserName, pagination: pagination) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userNames):
                self.searchResultUserNames = userNames
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}
