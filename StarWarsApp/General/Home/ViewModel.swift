import Foundation

enum LoadState {
    case nextPage(Int)
    case loadingPage(Int)
    case hasAllResults
    
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
}

class ViewModel {
    
    private enum Constants {
        static let initialLoadState: LoadState = .nextPage(1)
    }
    
    var people: [Person] {
        return isSearching ? searchedPeople : loadedPeople
    }
    
    var loadState: LoadState = Constants.initialLoadState
    private let services: Services
    private var loadedPeople: [Person] = []
    var searchedPeople: [Person] = []
    private(set) var isSearching: Bool = false
    var searchText: String? {
        didSet {
            searchTextDidChange(to: searchText)
        }
    }
    
    var onWillLoadData: (() -> ())?
    var onDataChanged: ((Bool) -> ())?
    
    init(services: Services) {
        self.services = services
    }
    
    var canLoadMore: Bool {
        return loadState.isNextPage && !isSearching
    }
    
    var canRefresh: Bool {
        return isSearching && people.isEmpty && !loadState.isLoadingPage
    }
    
    func loadData() {
        guard case let .nextPage(page) = loadState else {
            onDataChanged?(false)
            return
        }
        
        loadState = .loadingPage(page)
        onWillLoadData?()
        
        services.getCharacters(searchText: searchText, pageNumber: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if page == 1 {
                    self.loadedPeople = response.results
                } else {
                    self.loadedPeople.append(contentsOf: response.results)
                }
                
                if response.results.count < response.count {
                    self.loadState = .nextPage(page + 1)
                } else {
                    self.loadState = .hasAllResults
                }
                self.onDataChanged?(true)
            case .failure(let error):
                print("Failed to fetch people: \(error.localizedDescription)")
                self.loadState = .nextPage(page) // Keep the current page
                self.onDataChanged?(false)
            }
        }
    }
    
    func reloadData() {
        loadState = Constants.initialLoadState
        loadData()
    }
    
    
    func searchTextDidChange(to searchText: String?) {
        guard let searchText = searchText?.lowercased(), !searchText.isEmpty else {
            isSearching = false
            searchedPeople = []
            loadState = .nextPage(1)
            onDataChanged?(true)
            return
        }
        
        guard case let .nextPage(page) = loadState else {
            onDataChanged?(false)
            return
        }
        
        loadState = .loadingPage(page)
        onWillLoadData?()
        isSearching = true
        
        services.getCharacters(searchText: searchText, pageNumber: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if page == 1 {
                    self.searchedPeople = response.results
                } else {
                    self.searchedPeople.append(contentsOf: response.results)
                }
                
                if response.results.count + self.searchedPeople.count < response.count {
                    self.loadState = .nextPage(page + 1)
                } else {
                    self.loadState = .hasAllResults
                }
                self.onDataChanged?(true)
            case .failure(let error):
                print("Failed to fetch people: \(error.localizedDescription)")
                
                if page == 1 {
                    self.loadState = .nextPage(1)
                } else {
                    self.loadState = .nextPage(page)
                }
                self.onDataChanged?(false)
            }
        }
    }
    
}

