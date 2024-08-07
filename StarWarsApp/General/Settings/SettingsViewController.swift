//
//  TabBarController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 30/07/2024.
//


import UIKit
import AVKit
import WebKit

//MARK: - Controler Delegate

protocol SettingsViewControllerDelegate: AnyObject {
    func settingsviewController(_ viewController: SettingsViewController, needsToOpenLink link: Link)
}

class SettingsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Variables
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    private let viewModel: SettingsViewModel
    weak var delegate: SettingsViewControllerDelegate?
    
    //MARK: - Initialization
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -  View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        loadSettings()
    }
    
    //MARK: - Setup
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NameAgeCell.self, forCellWithReuseIdentifier: "NameAgeCell")
        collectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: "ProfileImageCell")
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        collectionView.register(SpacerCell.self, forCellWithReuseIdentifier: "SpacerCell")
        collectionView.register(LinkCell.self, forCellWithReuseIdentifier: "LinkCell")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pin(to: view)
    }
    
    //MARK: - Loading View
    
    func loadSettings() {
        viewModel.fetchSettings {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - UICollectionView DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let user = viewModel.user else { return 0 }
        switch section {
        case 0: return 2
        case 1: return 1 + user.links.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let user = viewModel.user else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
                if let imageUrl = URL(string: user.imageURL) {
                    cell.configure(with: imageUrl)
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NameAgeCell", for: indexPath) as! NameAgeCell
                let age = viewModel.calculateAge(from: user.birthdate) ?? 0
                cell.configure(name: user.name, age: age)
                return cell
            }
        case 1:
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
                if let videoUrl = URL(string: user.videoURL) {
                    cell.configure(with: videoUrl)
                }
                return cell
            } else if indexPath.item == 1 {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "SpacerCell", for: indexPath)
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LinkCell", for: indexPath) as! LinkCell
                let link = user.links[indexPath.item - 2]
                cell.configure(with: link.title, tag: indexPath.item - 2, target: self, action: #selector(linkButtonTapped(_:)))
                return cell
            }
        default:
            return UICollectionViewCell()
        }
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20
        switch indexPath.section {
        case 0:
            if indexPath.item == 0 {
                return CGSize(width: width, height: width * 0.30)
            } else {
                return CGSize(width: width, height: 10)
            }
        case 1:
            if indexPath.item == 0 {
                return CGSize(width: width, height: 50)
            } else if indexPath.item == 1 {
                return CGSize(width: width, height: 220)
            } else {
                return CGSize(width: width, height: 30) 
            }
        default:
            return CGSize.zero
        }
    }
    
    //MARK: - Button Tapped Delegate
    
    @objc private func linkButtonTapped(_ sender: UIButton) {
        guard let user = viewModel.user else { return }
        let link = user.links[sender.tag]
        delegate?.settingsviewController(self, needsToOpenLink: link)
    }
}
