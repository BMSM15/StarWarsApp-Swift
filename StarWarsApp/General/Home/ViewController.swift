//
//  ViewController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 17/07/2024.
//

import UIKit

// MARK: - View Controler Delegate

protocol ViewControllerDelegate: AnyObject {
    func viewController(_ viewController: ViewController, needsOpenDetailsForCharacter person: Person)
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    let viewModel: ViewModel
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    weak var delegate: ViewControllerDelegate?
    let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Initialization
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupCollectionView()
        setupActivityIndicator()
        viewModel.onDataChanged = { [weak self] _ in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.activityIndicator.stopAnimating()
                self?.collectionView.reloadData()
                self?.toogleRefreshControl()
            }
        }
        viewModel.onWillLoadData = { [weak self] in
            self?.activityIndicator.startAnimating()
            self?.toogleRefreshControl()
        }
        loadData()
    }
    
    // MARK: - Refresh Controler
        
    private func toogleRefreshControl() {
        if viewModel.canRefresh {
            removeRefreshControl()
        } else {
           addRefreshControl()
        }
    }
    
    private func addRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.pullRefresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    private func removeRefreshControl() {
        refreshControl.removeFromSuperview()
    }
    
    @objc func pullRefresh(_ sender: AnyObject) {
        reloadData()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StarWarsCell.self, forCellWithReuseIdentifier: "StarWarsCell")
        view.addSubview(collectionView)
        collectionView.pinTop(to: view)
        collectionView.pinBottom(to: view)
        collectionView.pinLeading(to: view)
        collectionView.pinTrailing(to: view)
    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search Characters"
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Load Data
    
    private func loadData() {
        guard viewModel.canLoadMore else {
            return
        }
        viewModel.loadData()
    }
    
    func reloadData() {
        viewModel.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StarWarsCell", for: indexPath) as! StarWarsCell
        let person = viewModel.people[indexPath.item]
        cell.configure(with: person)
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 10, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPerson = viewModel.people[indexPath.item]
        delegate?.viewController(self, needsOpenDetailsForCharacter: selectedPerson)
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 200,
           viewModel.canLoadMore {
            viewModel.loadData()
        }
    }
}

// MARK: - UISearchResultsUpdating

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.search(text: searchController.searchBar.text)
    }
}
