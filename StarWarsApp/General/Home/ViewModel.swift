//
//  TabBarController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 17/07/2024.
//

import Foundation

enum LoadState: Equatable {
    case nextPage(Int, searchText: String?)
    case loadingPage(Int, searchText: String?)
    case hasAllResults(searchText: String?)
    
    var isNextPage: Bool {
        if case .nextPage = self { return true }
        return false
    }
    
    var isLoadingPage: Bool {
        if case .loadingPage = self { return true }
        return false
    }
    
    var isHasAllResults: Bool {
        if case .hasAllResults = self { return true }
        return false
    }
    
    var searchText: String? {
        switch self {
        case let .nextPage(_, searchText),
            let .loadingPage(_, searchText),
            let .hasAllResults(searchText):
            return searchText
        }
    }
    
    static func ==(lhs: LoadState, rhs: LoadState) -> Bool {
        switch (lhs, rhs) {
        case (let .nextPage(lPage, lSearchText), let .nextPage(rPage, rSearchText)):
            return (lPage == rPage) && (lSearchText == rSearchText)
        case (let .loadingPage(lPage, lSearchText), let .loadingPage(rPage, rSearchText)):
            return (lPage == rPage) && (lSearchText == rSearchText)
        case (let .hasAllResults(lSearchText), let .hasAllResults(rSearchText)):
            return (lSearchText == rSearchText)
        default:
            return false
        }
    }
}

class ViewModel {
    
    private enum Constants {
        static let initialLoadState: LoadState = .nextPage(1, searchText: nil)
    }
    
    var people: [Person] = []
    
    var loadState: LoadState = Constants.initialLoadState
    private let services: Services
    var onWillLoadData: (() -> ())?
    var onDataChanged: ((Bool) -> ())?
    
    init(services: Services) {
        self.services = services
    }
    
    var canLoadMore: Bool {
        return loadState.isNextPage
    }
    
    var canRefresh: Bool {
        return people.isEmpty && !loadState.isLoadingPage
    }
        
    func loadData() {
        guard case let .nextPage(page, searchText) = loadState else {
            onDataChanged?(false)
            return
        }
        
        loadState = .loadingPage(page, searchText: searchText)
        
        onWillLoadData?()
        
        services.getCharacters(searchText: searchText, pageNumber: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if page == 1 {
                    self.people = response.results
                } else {
                    self.people.append(contentsOf: response.results)
                }
                
                print("💡 \(self.people.count) \(response.count)")
                if self.people.count < response.count {
                    self.loadState = .nextPage(page + 1, searchText: searchText)
                } else {
                    self.loadState = .hasAllResults(searchText: searchText)
                }
                self.onDataChanged?(true)
            case .failure(let error):
                print("Failed to fetch people: \(error.localizedDescription)")
                self.loadState = .nextPage(page, searchText: searchText) // Keep the current page
                self.onDataChanged?(false)
            }
        }
    }
    
    func search(text: String?) {
        guard text != loadState.searchText else {
            return
        }
        loadState = .nextPage(1, searchText: text)
        loadData()
    }

    func reloadData() {
        loadState = Constants.initialLoadState
        loadData()
    }
}
