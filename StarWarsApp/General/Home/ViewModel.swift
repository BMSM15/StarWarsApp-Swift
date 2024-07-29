import Foundation
import UIKit

enum LoadState {
    case nextPage(Int)
    case loadingPage(Int)
    case hasAllResults
    
    var isNextPage: Bool {
        switch self {
        case .nextPage:
            return true
        default:
            return false
        }
    }

    var isLoadingPage: Bool {
        switch self {
        case .loadingPage:
            return true
        default:
            return false
        }
    }

    var isHasAllResults: Bool {
        switch self {
        case .hasAllResults:
            return true
        default:
            return false
        }
    }
}

class ViewModel {
    
    private enum Constants {
        static let initialLoadState: LoadState = .nextPage(1)
    }
    
    var people: [Person] {
        return isFiltering ? filteredPeople : loadedPeople
    }
    private var loadState: LoadState = .nextPage(1)
    private let services : Services
    private var loadedPeople: [Person] = []
    private var filteredPeople: [Person] = []
    private var isFiltering: Bool = false
        
    
    
    init(services: Services) {
        self.services = services
    }
    
    var canLoadMore: Bool {
        return loadState.isNextPage && !isFiltering
    }
    
    func loadData(completion: @escaping (Bool) -> Void) {
        guard case let .nextPage(page) = loadState else {
            completion(false)
            return
        }
        loadState = .loadingPage(page)
        services.getCharacters(pageNumber: page) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let response):
                if page == 1 {
                    self.loadedPeople = response.results
                } else {
                    self.loadedPeople.append(contentsOf: response.results)
                }
                
                print("Total People Count: \(self.loadedPeople.count)")
                if self.loadedPeople.count < response.count {
                    self.loadState = .nextPage(page + 1)
                } else {
                    self.loadState = .hasAllResults
                }
                completion(true)
            case .failure(let error):
                print("Failed to fetch people: \(error.localizedDescription)")
                self.loadState = .nextPage(page)
                completion(false)
            }
        }
    }
    
    func reloadData(completion: @escaping (Bool) -> Void) {
        loadState = .nextPage(1)
        loadData(completion: completion)
    }
}

extension ViewModel {
        
    public func searchTextDidChange(to searchText: String?) {
        guard let searchText = searchText?.lowercased(),
              !searchText.isEmpty else {
            isFiltering = false
            filteredPeople = []
            return
        }
        isFiltering = true
        filteredPeople = loadedPeople.filter {
            $0.name.lowercased().contains(searchText)
        }
    }
}
