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
    
    //MARK: - Variables
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    let errorViewController = ErrorViewController()
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
        setupIndicator()
        setupActions()
    }
    
    //MARK: - Setup
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NameAgeCell.self, forCellWithReuseIdentifier: CellIndentifier.nameAgeCell)
        collectionView.register(ProfileImageCell.self, forCellWithReuseIdentifier: CellIndentifier.profileImageCell)
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: CellIndentifier.videoCell)
        collectionView.register(LinkCell.self, forCellWithReuseIdentifier: CellIndentifier.linkCell)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellIndentifier.headerViewString)
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellIndentifier.headerCell)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pin(to: view)
    }
    
    func setupIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.centerHorizontally(to: view)
        activityIndicator.centerVertically(to: view)
        activityIndicator.tintColor = .red
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
    
    //MARK: - Loading View
    
    func loadSettings() {
        activityIndicator.startAnimating()
        viewModel.fetchSettings {
            DispatchQueue.main.async {
                if Int.random(in: 0...10) > 7 {
                    self.collectionView.reloadData()
                } else {
                    self.showErrorView()
                }
                self.activityIndicator.stopAnimating()
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
            
        case .links(let links):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIndentifier.linkCell, for: indexPath) as! LinkCell
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
            
        case .links:
            return CGSize(width: width, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionItem = viewModel.sections[indexPath.section]
        
        switch sectionItem {
        case .profileImage, .nameAndAge, .video:
            break
            
        case .links(let links):
            let selectedLink = links[indexPath.item]
            delegate?.settingsviewController(self, needsToOpenLink: selectedLink)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CellIndentifier.headerCell, for: indexPath) as! HeaderCell
        headerView.configure(with: headerText(for: indexPath.section))
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    private func headerText(for section: Int) -> String {
        let sectionItem = viewModel.sections[section]
        switch sectionItem {
        case .nameAndAge:
            return "User Data"
        case .links:
            return "Links"
        default:
            return ""
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
