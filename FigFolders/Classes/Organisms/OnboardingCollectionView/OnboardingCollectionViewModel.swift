//
//  OnboardingCollectionViewModel.swift
//  FigFolders
//
//  Created by Lourdes on 5/10/21.
//

import Foundation

class OnboardingCollectionViewModel {
    let titles = ["Share & Store your files", "Trending Topics", "Build Conversation"]
    let content = [["Get paid for your valuable stuff", "Try buying a few"], ["Build conversation", "Try buying a few"], ["Meet new people around the globe", "Start Chatting"]]
    let numberOfCells = 3
    
    var currentIndex = 0
    
    var nextIndex: IndexPath? {
        if currentIndex >= 2 { return nil }
        currentIndex += 1
        return IndexPath(row: currentIndex , section: 0)
    }
    
    func getTitleAtIndex(_ index: Int) -> String {
        titles[index]
    }
    
    func getContentFirstLineAtIndex(_ index: Int) -> String {
        content[index][0]
    }
    
    func getContentSecondLineAtIndex(_ index: Int) -> String {
        content[index][1]
    }
}
