//
//  DetailsViewControler.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 17/07/2024.
//

import UIKit

class DetailViewController: UIViewController {
    
    var viewModel: CharacterDetailsViewModel? {
        didSet {
            setupUI()
            fetchVehicles()
        }
    }
    
    // Componentes UI
    private let nameLabel = UILabel()
    private let genderLabel = UILabel()
    private let languageImageView = UIImageView()
    private let vehiclesLabel = UILabel()
    
    // Método chamado quando a visão é carregada
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    // Configuração dos componentes da visão
    private func setupViews() {
        view.addSubview(nameLabel)
        view.addSubview(genderLabel)
        view.addSubview(languageImageView)
        view.addSubview(vehiclesLabel)
        
        // Desativando a propriedade translatesAutoresizingMaskIntoConstraints para usar Auto Layout
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        languageImageView.translatesAutoresizingMaskIntoConstraints = false
        vehiclesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configurações das labels e da imagem
        nameLabel.textAlignment = .left
        genderLabel.textAlignment = .left
        vehiclesLabel.textAlignment = .left
        vehiclesLabel.numberOfLines = 0
        vehiclesLabel.lineBreakMode = .byWordWrapping
        languageImageView.contentMode = .scaleAspectFit
    }
    
    // Configuração das restrições de Auto Layout
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
    
    // Configuração da interface do usuário com dados do ViewModel
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        
        title = viewModel.name
        nameLabel.text = "Name: \(viewModel.name)"
        genderLabel.text = "Gender: \(viewModel.gender)"
        
        // Baixar imagem de avatar
        if let url = URL(string: viewModel.avatarURL) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.languageImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    // Busca os detalhes dos veículos
    private func fetchVehicles() {
        guard let viewModel = viewModel else { return }
        
        print("Fetching vehicles for character: \(viewModel.name)")
        viewModel.fetchVehicles { vehicles in
            print("Fetched vehicles: \(vehicles)")
            DispatchQueue.main.async {
                self.vehiclesLabel.text = "Vehicles: \(vehicles.joined(separator: ", "))"
            }
        }
    }
}
