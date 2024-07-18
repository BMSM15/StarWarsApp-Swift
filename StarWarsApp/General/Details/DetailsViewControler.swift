import UIKit

class DetailViewController: UIViewController {
    var viewModel: DetailsViewModel? {
        didSet {
            setupUI()
        }
    }
    
    private let nameLabel = UILabel()
    private let genderLabel = UILabel()
    private let languageImageView = UIImageView()
    private let vehiclesLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(nameLabel)
        view.addSubview(genderLabel)
        view.addSubview(languageImageView)
        view.addSubview(vehiclesLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        languageImageView.translatesAutoresizingMaskIntoConstraints = false
        vehiclesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.textAlignment = .left
        genderLabel.textAlignment = .left
        vehiclesLabel.textAlignment = .left
        vehiclesLabel.numberOfLines = 0
        vehiclesLabel.lineBreakMode = .byWordWrapping
        languageImageView.contentMode = .scaleAspectFit
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            genderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            genderLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            vehiclesLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 20),
            vehiclesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            vehiclesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            languageImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            languageImageView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20),
            languageImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            languageImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        
        title = viewModel.character.name
        nameLabel.text = "Name: \(viewModel.character.name)"
        genderLabel.text = "Gender: \(viewModel.character.gender)"
        
        languageImageView.setImageURL(viewModel.character.avatarURL)
        
        vehiclesLabel.text = (viewModel.character.vehicles)
    }
}

extension UIImageView {
    
    func setImageURL(_ url: String) {
        setImageURL(URL(string: url))
    }
    
    func setImageURL(_ url: URL?) {
        guard let url = url else {
            self.image = nil
            return
        }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}

/*
 detailsViewModel.fetchCharacterDetails(for: selectedPerson) { [weak self] details in
     DispatchQueue.main.async {
         let detailVC = DetailViewController()
         var detailsViewModel = DetailsViewModel(character: details)
         self?.navigationController?.pushViewController(detailVC, animated: true)
     }
 }
 */
 

