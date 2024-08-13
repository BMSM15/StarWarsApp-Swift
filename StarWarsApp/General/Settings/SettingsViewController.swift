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
        layout.minimumLineSpacing = 100
        layout.minimumInteritemSpacing = 100
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    private let viewModel: SettingsViewModel
    weak var delegate: SettingsViewControllerDelegate?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    let errorViewController = ErrorViewController()
    
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
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NameAgeCell.self, forCellWithReuseIdentifier: "NameAgeCell")
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: "GalleryCell")
        collectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: "ProfileImageCell")
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        collectionView.register(LinkCell.self, forCellWithReuseIdentifier: "LinkCell")
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCell")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pin(to: view)
        
        
    }
    
    private func setupActions() {
        errorViewController.retryButtonHandler = { [weak self] in
            self?.loadSettings()
            self?.hideErrorView()
        }
        errorViewController.goBackButtonHandler = { [weak self] in
            self?.delegate?.settingsviewControllerNeedToGoHome(self!)
        }
    }
    
    func showErrorView() {
        self.add(errorViewController)
    }
    
    func hideErrorView() {
        remove(errorViewController)
    }
    
    // MARK: - Loading View
    
    func loadSettings() {
        activityIndicator.startAnimating()
        viewModel.fetchSettings {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            self.activityIndicator.stopAnimating()
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
            return cell
            
        case .nameAndAge(let name, let age):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIndentifier.nameAgeCell, for: indexPath) as! NameAgeCell
            cell.configure(name: name, age: age)
            return cell
            
        case .video(let url):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIndentifier.videoCell, for: indexPath) as! VideoCell
            cell.configure(with: url)
            return cell
            
        case .link(let link):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIndentifier.linkCell, for: indexPath) as! LinkCell
            cell.configure(with: link.title)
            return cell
            
        case .image(let imageURL):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIndentifier.galleryCell, for: indexPath) as! GalleryCell
            cell.configure(with: imageURL)
            return cell
            
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.debug(color: .red)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionInset = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let sectionWidth = collectionView.frame.width - sectionInset.left - sectionInset.right
        let section = viewModel.sections[indexPath.section]
        let item = section.items[indexPath.item]
        
        switch item {
        case .profileImage:
            return CGSize(width: sectionWidth, height: sectionWidth * 0.30)
            
        case .nameAndAge:
            return CGSize(width: sectionWidth, height: 60)
            
        case .video:
            return CGSize(width: sectionWidth, height: 220)
            
        case .link:
            return CGSize(width: sectionWidth, height: 50)
            
        case .image:
            
            let numberOfColumns: CGFloat = 3
            let lineSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: indexPath.section)
            let itemSize = (sectionWidth - (numberOfColumns - 1) * lineSpacing) / numberOfColumns
            return CGSize(width: itemSize, height: itemSize)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]
        let item = section.items[indexPath.item]
        
        switch item {
        case .profileImage, .nameAndAge, .video:
            break
            
        case .image:
            let imageURLs = section.items.compactMap { item -> URL? in
                if case .image(let url) = item {
                    return url
                }
                return nil
            }
            
            let slideshowVC = SlideShowViewController(imageURLs: imageURLs, initialPage: indexPath.item)
            present(slideshowVC, animated: true, completion: nil)
            
            
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
    static let galleryCell = "GalleryCell"
}

//MARK: - UIView Extension

extension UIView {
    
    func debug(color: UIColor) {
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
    }
}
