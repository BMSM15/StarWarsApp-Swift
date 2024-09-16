//
//  DetailsViewController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 20/07/2024.
//


import UIKit

// MARK: - Delegate Controller

protocol DetailsViewControllerDelegate: AnyObject {
    func detailsViewControllerNeedsToGoBack()
}

class DetailsViewController: UIViewController {
    
    // MARK: - Variables
    
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
    
    // MARK: - Initialization
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        loadCharacterDetails()
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        errorViewController.retryButtonHandler = { [weak self] in
            self?.loadCharacterDetails()
            self?.hideErrorView()
        }
        errorViewController.goBackButtonHandler = { [weak self] in
            self?.delegate?.detailsViewControllerNeedsToGoBack()
        }
    }
    
    func showErrorView() {
        self.add(errorViewController)
    }
    
    func hideErrorView() {
        remove(errorViewController)
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
        
        principalStackView.pinSafeAreaTop(to: view, constant: 10)
        principalStackView.pinBottom(to: view, constant: 10)
        principalStackView.pinTrailing(to: view, constant: 10)
        principalStackView.pinLeading(to: view, constant: 10)
        
        textStackView.pinLeading(to: principalStackView, constant: 10)
        textStackView.widthEqual(to: principalStackView, multiplier: 0.5)
        
        imageStackView.pinLeading(to: textStackView, constant: 250)
        imageStackView.heightEqual(to: principalStackView, multiplier: 0.15)
        
        activityIndicator.centerHorizontally(to: view)
        activityIndicator.centerVertically(to: view)
        activityIndicator.tintColor = .red
    }
    
    // MARK: - Functions
    
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

// MARK: - Extensions

extension UIViewController {
    
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
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
