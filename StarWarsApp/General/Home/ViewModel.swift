import Foundation

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
    private let urlPerson = "https://swapi.dev/api/people"
    var people: [Person] = []
    var fetchedURLs: Set<String> = [] // Track fetched URLs to prevent duplicates
    var loadState: LoadState = .nextPage(1)
    let services : Services
    
    init(services: Services) {
        self.services = services
    }
    
    var canLoadMore: Bool {
        return loadState.isNextPage
    }
    
    func fetchData(completion: @escaping (Bool) -> Void) {
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
                self.people.append(contentsOf: response.results)
                print("Total People Count: \(self.people.count)")
                if self.people.count < response.count {
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
}




// StarWarsCell usar constraints e divir as labels em 2---------
// Dependency injection 
//StackViews


