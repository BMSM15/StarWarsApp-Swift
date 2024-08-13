//
//  SlideShowViewController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 12/08/2024.
//

import UIKit

class SlideShowViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Variables
    
    private var imageURLs: [URL]
    let pageControl = UIPageControl()
    let initialPage: Int
    var currentPage: Int
    
    // MARK: - Initialization
    
    init(imageURLs: [URL], initialPage: Int) {
        self.imageURLs = imageURLs
        self.initialPage = initialPage
        self.currentPage = initialPage
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        setup()
        setupPageControl()
    }
    
    // MARK: - Setup
    
    private func setup() {
        dataSource = self
        delegate = self
        
        let slideViewController = viewController(at: initialPage)
        setViewControllers([slideViewController], direction: .forward, animated: true, completion: nil)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = imageURLs.count
        pageControl.currentPage = initialPage
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
    
        pageControl.pinSafeAreaBottom(to: view, constant: 150)
        pageControl.centerHorizontally(to: view)
    }
    
    // MARK: - UIPageViewControllerDelegate
    
    func viewController(at index: Int) -> UIViewController {
        let imageVC = GalleryImageViewController()
        imageVC.imageURL = imageURLs[index]
        imageVC.pageIndex = index
        return imageVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? GalleryImageViewController else { return nil }
        let index = viewController.pageIndex
        return index == 0 ? nil : self.viewController(at: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? GalleryImageViewController else { return nil }
        let index = viewController.pageIndex
        return index == imageURLs.count - 1 ? nil : self.viewController(at: index + 1)
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
