import UIKit

class DetailsViewController: UIViewController {
    var viewModel: DetailsViewModel? {
        didSet {
            setupUI()
            updatefetchCharacterDetails()
        }
    }
    
    private let nameLabel = UILabel()
    private let genderLabel = UILabel()
    private let languageImageView = UIImageView()
    private let vehiclesLabel = UILabel()
    let container: UIView = .init()
    
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
         
            nameLabel.pinTop(to: view, constant: 110)
            nameLabel.pinLeading(to: view, constant: 10)
            nameLabel.widthEqual(to: view, multiplier: 0.5).activate()
            
            genderLabel.pinTop(to: nameLabel, constant: 30)
            genderLabel.pinLeading(to: view, constant: 10)
            genderLabel.widthEqual(to: view, multiplier: 0.5).activate()
                    
            vehiclesLabel.pinTop(to: genderLabel, constant: 30)
            vehiclesLabel.pinLeading(to: view, constant: 10)
            vehiclesLabel.widthEqual(to: view, multiplier: 0.5).activate()
                    
            languageImageView.pinTop(to: view, constant: 110)
            languageImageView.pinLeading(to: nameLabel, constant: 200)
            languageImageView.pinTrailing(to: view, constant: -10)
            languageImageView.heightEqual(to: view, multiplier: 0.17).activate()

        
    }
    
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        
        // Set title and labels
        title = "StarWars Character"
        nameLabel.text = "Name: \(viewModel.character.name)"
        genderLabel.text = "Gender: \(viewModel.character.gender)"
        
        // Load avatar image asynchronously
        languageImageView.setImageURL(viewModel.character.avatarURL)
    }

    private func updatefetchCharacterDetails() {
        guard let viewModel = viewModel else { return }
        
        viewModel.fetchCharacterDetails { [weak self] details in
            DispatchQueue.main.async {
                self?.updateUI(with: details)
            }
        }
    }

    private func updateUI(with details: CharacterDetails) {
        nameLabel.text = "Name: \(details.name)"
        genderLabel.text = "Gender: \(details.gender)"
        vehiclesLabel.text = "Vehicles: \(details.vehicles.joined(separator: ", "))"
        languageImageView.setImageURL(details.avatarURL)
    }
}

extension UIView{
    
    func usesAutoLayout() {
            translatesAutoresizingMaskIntoConstraints = false
        }
    
    @discardableResult
    func widthEqual(to view: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: constant).activate()
    }
    
    @discardableResult
    func heightEqual(to view: UIView, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        usesAutoLayout()
        return heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).activate()
    }

    
    @discardableResult
    func pinTop(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return topAnchor.constraint(equalTo: view.topAnchor, constant: constant).activate()
    }
    @discardableResult
        func pinLeading(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
            usesAutoLayout()
            return leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).activate()
        }
    @discardableResult
        func pinTrailing(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
            usesAutoLayout()
            return trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).activate()
        }
    @discardableResult
        func pinWidth(to constant: CGFloat) -> NSLayoutConstraint {
            usesAutoLayout()
            return widthAnchor.constraint(equalToConstant: constant).activate()
        }

        @discardableResult
        func pinHeight(to constant: CGFloat) -> NSLayoutConstraint {
            usesAutoLayout()
            return heightAnchor.constraint(equalToConstant: constant).activate()
        }
}

extension NSLayoutConstraint {
    @discardableResult
    func activate() -> NSLayoutConstraint {
        isActive = true
        return self
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
