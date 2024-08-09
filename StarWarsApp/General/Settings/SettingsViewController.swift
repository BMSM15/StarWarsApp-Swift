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
    func settingsviewControllerNeedToGoHome (_ viewController: SettingsViewController)
}

class SettingsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let viewModel: SettingsViewModel
    weak var delegate: SettingsViewControllerDelegate?
    
    // MARK: - Initialization
    
    init(viewModel: SettingsViewModel) {
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
        setupCollectionView()
        loadSettings()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NameAgeCell.self, forCellWithReuseIdentifier: "NameAgeCell")
        collectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: "ProfileImageCell")
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        collectionView.register(LinkCell.self, forCellWithReuseIdentifier: "LinkCell")
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCell")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pin(to: view)
    }
    
    // MARK: - Loading View
    
    func loadSettings() {
        viewModel.fetchSettings {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - UICollectionView DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = viewModel.sections[indexPath.section]
        let item = section.items[indexPath.item]
        
        switch item {
        case .profileImage(let url):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIndentifier.profileImageCell, for: indexPath) as! ProfileImageCell
            cell.configure(with: url)
            cell.debug(color: .red)
            return cell
            
        case .nameAndAge(let name, let age):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIndentifier.nameAgeCell, for: indexPath) as! NameAgeCell
            cell.configure(name: name, age: age)
            cell.debug(color: .red)
            return cell
            
        case .video(let url):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIndentifier.videoCell, for: indexPath) as! VideoCell
            cell.configure(with: url)
            cell.debug(color: .red)
            return cell
            
        case .link(let link):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIndentifier.linkCell, for: indexPath) as! LinkCell
            cell.configure(with: link.title)
            cell.debug(color: .red)
            return cell
        }
    }
    
    // MARK: - Header Configuration
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellIndentifier.headerCell, for: indexPath) as! HeaderCell
        header.label.text = viewModel.sections[indexPath.section].title
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            let title = viewModel.sections[section].title
            if title == nil {
                return CGSize(width: collectionView.frame.width, height: 10)
            } else {
                return CGSize(width: collectionView.frame.width, height: 40)
            }
        }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 20
        let section = viewModel.sections[indexPath.section]
        let item = section.items[indexPath.item]
        
        switch item {
        case .profileImage:
            return CGSize(width: width, height: width * 0.30)
            
        case .nameAndAge:
            return CGSize(width: width, height: 60)
            
        case .video:
            return CGSize(width: width, height: 220)
            
        case .link:
            return CGSize(width: width, height: 50)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]
        let item = section.items[indexPath.item]
        
        switch item {
        case .profileImage, .nameAndAge, .video:
            break
            
        case .link(let link):
            delegate?.settingsviewController(self, needsToOpenLink: link)
        }
    }
}


//MARK: - Cell Identifier Enum

enum CellIndentifier {
    static let nameAgeCell = "NameAgeCell"
    static let videoCell = "VideoCell"
    static let linkCell = "LinkCell"
    static let profileImageCell = "ProfileImageCell"
    static let headerViewString = "HeaderView"
    static let headerCell = "HeaderCell"
}

//MARK: - UIView Extension

extension UIView {
    
    func debug(color: UIColor) {
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
    }
}
