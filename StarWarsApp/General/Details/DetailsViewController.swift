import UIKit

protocol DetailsViewControllerDelegate: AnyObject {
    func goBackToViewController()
}

class DetailsViewController: UIViewController {
    let viewModel: DetailsViewModel
    
    private let nameLabel = UILabel()
    private let genderLabel = UILabel()
    private let languageImageView = UIImageView()
    private let vehiclesLabel = UILabel()
    private let principalStackView = UIStackView()
    private let imageStackView = UIStackView()
    private let textStackView = UIStackView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    let errorViewController = ErrorViewController()
    weak var delegate: DetailsViewControllerDelegate?
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupActions() {
        errorViewController.retryButtonHandler = { [weak self] in
            self?.loadCharacterDetails()
            self?.hideErrorView()
        }
        errorViewController.goBackButtonHandler = { [weak self] in
            self?.delegate?.goBackToViewController()
        }
    }
    
    func showErrorView() {
        //errorViewController.delegate = self
        
        self.add(errorViewController)
    }
    
    func hideErrorView() {
        remove(errorViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        loadCharacterDetails()
        setupActions()
    }
    
    private func setupViews() {
        title = "StarWars Character"
        
        view.addSubview(principalStackView)
        view.addSubview(languageImageView)
        view.addSubview(activityIndicator)
        
        nameLabel.textAlignment = .left
        genderLabel.textAlignment = .left
        vehiclesLabel.textAlignment = .left
        vehiclesLabel.numberOfLines = 0
        vehiclesLabel.lineBreakMode = .byWordWrapping
        
        principalStackView.axis = .horizontal
        principalStackView.alignment = .leading
        principalStackView.distribution = .equalSpacing
        
        principalStackView.addArrangedSubview(textStackView)
        principalStackView.addArrangedSubview(imageStackView)
        
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.distribution = .equalSpacing
        
        textStackView.spacing = 10
        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(genderLabel)
        textStackView.addArrangedSubview(vehiclesLabel)
        
        imageStackView.axis = .horizontal
        imageStackView.addArrangedSubview(languageImageView)
        imageStackView.contentMode = .scaleAspectFit
        
        principalStackView.translatesAutoresizingMaskIntoConstraints = false
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
    }
    
    
    private func setupConstraints() {
        
        principalStackView.pinTopSafeArea(to: view, constant: 10)
        principalStackView.pinBottom(to: view, constant: 10)
        principalStackView.pinTrailing(to: view, constant: 10)
        principalStackView.pinLeading(to: view, constant: 10)
        
        textStackView.pinTop(to: principalStackView, constant: 50)
        textStackView.pinLeading(to: principalStackView, constant: 10)
        textStackView.widthEqual(to: principalStackView, multiplier: 0.5)
        
        imageStackView.pinLeading(to: textStackView, constant: 250)
        imageStackView.heightEqual(to: principalStackView, multiplier: 0.15)
        
        activityIndicator.centerHorizontally(to: view)
        activityIndicator.centerVertically(to: view)
        activityIndicator.tintColor = .red
    }
    
    func loadCharacterDetails() {
        activityIndicator.startAnimating()
        self.viewModel.fetchCharacterDetails { [weak self] details in
            DispatchQueue.main.async {
                if Int.random(in: 0...10) > 5,
                   let details = details {
                    self?.updateUI(with: details)
                } else {
                    self?.showErrorView()
                }
                self?.activityIndicator.stopAnimating()
                
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

extension UIView {
    
    func usesAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @discardableResult
    func centerHorizontally(to parentView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: constant).activate()
    }
    
    @discardableResult
    func centerVertically(to parentView: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: constant).activate()
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
    func pinTopSafeArea(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant).activate()
    }

    
    @discardableResult
    func pinTop(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return topAnchor.constraint(equalTo: view.topAnchor, constant: constant).activate()
    }
    
    @discardableResult
    func pinBottom(to view: UIView, constant: CGFloat = 0) -> NSLayoutConstraint {
        usesAutoLayout()
        return bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).activate()
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

extension UIViewController {
    
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        //child.view.frame = self.view.frame
        if frame != nil {
            if let frame = frame {
                child.view.frame = frame
            }
        } else {
            child.view.frame = self.view.frame
        }
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
