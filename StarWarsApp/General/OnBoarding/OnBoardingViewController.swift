//
//  OnBoardingViewController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 20/08/2024.
//

import UIKit

protocol OnBoardingViewControllerDelegate: AnyObject {
    func onboardingDidFinish(_ controller: OnBoardingViewController)
}

class OnBoardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let viewModel: OnBoardingViewModel
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    weak var delegate: OnBoardingViewControllerDelegate?

    init(viewModel: OnBoardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnBoardingCell.self, forCellWithReuseIdentifier: "OnBoardingCell")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pin(to: view)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCards
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardingCell", for: indexPath) as! OnBoardingCell
        let card = viewModel.card(at: indexPath.item)
        
        cell.configure(with: card, pageIndex: indexPath.item, numberOfPages: viewModel.numberOfCards) { [weak self] in
            self?.nextButtonTapped()
        }
        
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    // MARK: - Actions

    private func nextButtonTapped() {
        guard let visibleIndexPath = collectionView.indexPathsForVisibleItems.first else { return }
        let nextIndex = visibleIndexPath.item + 1
        if nextIndex < viewModel.numberOfCards {
            let indexPath = IndexPath(item: nextIndex, section: .zero)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            delegate?.onboardingDidFinish(self)
        }
    }
}
