//
//  SlideShowViewController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 12/08/2024.
//

import UIKit

class SlideShowViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Variables
    
    private var imageDetails: [(url: URL, width: Int, height: Int)]
    let pageControl = UIPageControl()
    let initialPage: Int
    var currentPage: Int
    
    // MARK: - Initialization
    
    init(imageDetails: [(url: URL, width: Int, height: Int)], initialPage: Int) {
        self.imageDetails = imageDetails
        self.initialPage = initialPage
        self.currentPage = initialPage
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupPageControl()
    }
    
    // MARK: - Setup
    
    private func setup() {
        dataSource = self
        delegate = self
        
        if let slideViewController = viewController(at: initialPage) {
            setViewControllers([slideViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = imageDetails.count
        pageControl.currentPage = initialPage
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
    
        pageControl.pinSafeAreaBottom(to: view, constant: 150)
        pageControl.centerHorizontally(to: view)
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? GalleryImageViewController else { return nil }
        let previousIndex = viewController.pageIndex - 1
        return self.viewController(at: previousIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? GalleryImageViewController else { return nil }
        let nextIndex = viewController.pageIndex + 1
        return self.viewController(at: nextIndex)
    }

    private func viewController(at index: Int) -> GalleryImageViewController? {
        guard index >= 0, index < imageDetails.count else { return nil }
        let imageDetail = imageDetails[index]
        let imageVC = GalleryImageViewController()
        imageVC.imageURL = imageDetail.url
        imageVC.pageIndex = index
        imageVC.imageWidth = imageDetail.width
        imageVC.imageHeight = imageDetail.height
        return imageVC
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentVC = pageViewController.viewControllers?.first as? GalleryImageViewController {
                currentPage = currentVC.pageIndex
                pageControl.currentPage = currentPage
            }
        }
    }
}
