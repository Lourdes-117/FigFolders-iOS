//
//  SearchChatViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 6/5/21.
//

import Foundation
protocol SearchChatSelectionDelegate: AnyObject {
    func didSelectUser(_ emailID: String, _ username: String)
}

class SearchChatViewModel {
    let title = "Search Chat"
    let autoSearchMinTextLength = 3
}
