import Foundation

class ViewModel {
    private let urlPerson = "https://swapi.dev/api/people"
    var people: [Person] = []
    var fetchedURLs: Set<String> = [] // Track fetched URLs to prevent duplicates
    var currentPage: Int = 1
    var isFetching: Bool = false
    let maxPeopleCount: Int = 82
    private let services = Services()
    
    func fetchData(completion: @escaping () -> Void) {
        guard !isFetching, people.count < maxPeopleCount else { return }
        isFetching = true
        print("Fetching data from page \(currentPage)...")
        fetchPeople(from: "\(urlPerson)?page=\(currentPage)", completion: completion)
    }
    
    private func fetchPeople(from url: String, completion: @escaping () -> Void) {
        print("Fetching people from URL: \(url)")
        services.getCharacters(from: url) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let response):
                let newPeople = response.results.filter { !self.fetchedURLs.contains($0.url) }
                self.fetchedURLs.formUnion(newPeople.map { $0.url })
                self.people.append(contentsOf: newPeople)
                print("Total People Count: \(self.people.count)")
                
                if self.people.count < self.maxPeopleCount, let _ = response.next {
                    self.currentPage += 1
                }
            case .failure(let error):
                print("Failed to fetch people: \(error.localizedDescription)")
            }
            completion()
        }
    }
    
    
}
