//
//  OnBoardingViewController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 19/08/2024.
//

import UIKit

protocol OnBoardingViewControllerDelegate: AnyObject {
    func onboardingDidFinish(_ controller: OnBoardingViewController)
}

class OnBoardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Variables
    
    private let viewModel: OnBoardingViewModel
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    weak var delegate: OnBoardingViewControllerDelegate?
    private let pageControl = UIPageControl()
    private let nextButton = UIButton(type: .system)
    
    // MARK: - Initialization
    
    init(viewModel: OnBoardingViewModel) {
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
        setupPageControl()
        setupNextButton()
        setupConstraints()
    }
    
    // MARK: - Setup
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnBoardingCell.self, forCellWithReuseIdentifier: "OnBoardingCell")
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pin(to: view)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = viewModel.numberOfCards
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .blue
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        view.addSubview(pageControl)
    }
    
    private func setupNextButton() {
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
    }
    
    private func setupConstraints() {
        nextButton.setTitleColor(.black, for: .normal)
        
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .blue
        
        let stackView = UIStackView(arrangedSubviews: [pageControl, nextButton])
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.pinBottom(to: view, constant: 50)
        stackView.pinTrailing(to: view, constant: 50)
        stackView.pinLeading(to: view)
    }
    
    // MARK: - Actions
    
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateNextButtonTitle(for: sender.currentPage)
    }
    
    @objc private func nextButtonTapped() {
        let currentPage = pageControl.currentPage
        let isLastPage = currentPage == viewModel.numberOfCards - 1
        
        if isLastPage {
            delegate?.onboardingDidFinish(self)
        } else {
            let nextIndex = currentPage + 1
            let indexPath = IndexPath(item: nextIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            pageControl.currentPage = nextIndex
            nextButton.setTitle(nextIndex == viewModel.numberOfCards - 1 ? "Start" : "Next", for: .normal)
        }
    }
    
    private func updateNextButtonTitle(for pageIndex: Int) {
        let isLastPage = pageIndex == viewModel.numberOfCards - 1
        nextButton.setTitle(isLastPage ? "Start" : "Next", for: .normal)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
        updateNextButtonTitle(for: page)
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
}
