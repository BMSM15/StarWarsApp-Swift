import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchInitialData()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StarWarsCell.self, forCellWithReuseIdentifier: "StarWarsCell")
        view.addSubview(collectionView)
    }
    
    private func fetchInitialData() {
        viewModel.fetchData { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarWarsCell", for: indexPath) as! StarWarsCell
        
        let person = viewModel.people[indexPath.item]
        cell.nameLabel.text = "Name: \(person.name)"
        cell.genderLabel.text = "Gender: \(person.gender)"
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPerson = viewModel.people[indexPath.item]
        let characterDetails = CharacterDetails(
            name: selectedPerson.name,
            gender: selectedPerson.gender,
            language: "Unknown", // This will be fetched later
            avatarURL: "", // This will be generated later
            vehicles: []
        )
        let detailsViewModel = DetailsViewModel(character: characterDetails, person: selectedPerson)
        let detailsViewController = DetailsViewController()
        detailsViewController.viewModel = detailsViewModel
        navigationController?.pushViewController(detailsViewController, animated: true)
    }


    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 200 {
            fetchInitialData()
        }
    }
}

