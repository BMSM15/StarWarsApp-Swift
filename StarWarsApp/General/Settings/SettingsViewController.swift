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
        collectionView.register(NameAgeCell.self, forCellWithReuseIdentifier: CellIndentifier.nameAgeCell)
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
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionItem = viewModel.sections[indexPath.section]
        
        switch sectionItem {
        case .profileImage(let url):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
            cell.configure(with: url)
            return cell
            
        case .nameAndAge(let name, let age):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NameAgeCell", for: indexPath) as! NameAgeCell
            cell.configure(name: name, age: age)
            return cell
            
        case .video(let url):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
            cell.configure(with: url)
            return cell
            
        case .links(let links):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LinkCell", for: indexPath) as! LinkCell
            let link = links[indexPath.item]
            cell.configure(with: link.title)
            cell.debug(color: .red)
            return cell
        }
    }

    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20
        let sectionItem = viewModel.sections[indexPath.section]
        
        switch sectionItem {
        case .profileImage:
            return CGSize(width: width, height: width * 0.30)
            
        case .nameAndAge:
            return CGSize(width: width, height: 60)
            
        case .video:
            return CGSize(width: width, height: width * 0.56)
            
        case .links(let links):
            let title = links[indexPath.item].title
            return CGSize(width: width, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionItem = viewModel.sections[indexPath.section]
        
        switch sectionItem {
        case .profileImage, .nameAndAge, .video:
            // Handle non-link selections if needed
            break
            
        case .links(let links):
            let selectedLink = links[indexPath.item]
            delegate?.settingsviewController(self, needsToOpenLink: selectedLink)
        }
    }
}

//MARK: - Cell Identifier Enum

enum CellIndentifier {
    static let nameAgeCell = "NameAgeCell"
}

//MARK: - UIView Extension

extension UIView {
    
    func debug(color: UIColor) {
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
    }
}
