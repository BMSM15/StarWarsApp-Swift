//
//  TabBarController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 31/07/2024.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let services: Services = .init()
    let homeNavController = UINavigationController()
    let settingsNavController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        
        self.delegate = self
    }
    
    
    private func setupTabs() {
        let homeViewModel = ViewModel(services: services)
        let viewController = ViewController(viewModel: homeViewModel)
        let settingsViewModel = SettingsViewModel()
        let settingsViewController = SettingsViewController(viewModel: settingsViewModel)
        
        
        viewController.delegate = self
                
        self.configureNavigationController(homeNavController, title: "Home", image: UIImage(systemName: "house"), viewController: viewController)
        self.configureNavigationController(settingsNavController, title: "Settings", image: UIImage(systemName: "person"), viewController: settingsViewController)
        
       // let settings = self.createNav(with: "Settings", and: UIImage(systemName: "person"), vc: SettingsViewController(viewModel: settingsViewModel))
        
        self.setViewControllers([homeNavController, settingsNavController], animated: true)
    }
    
    private func configureNavigationController(_ navigationController: UINavigationController, title: String, image: UIImage?, viewController: UIViewController) {
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension TabBarController: ViewControllerDelegate {
    
    func viewController(_ viewController: UIViewController, needsOpenDetailsForCharacter person: Person) {
        print("needsOpenDetailsForCharacter")
        let detailsViewModel = DetailsViewModel(person: person, services: services)
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel)
        detailsViewController.delegate = self
        homeNavController.pushViewController(detailsViewController, animated: true)
    }
    
}

extension TabBarController: DetailsViewControllerDelegate {
    func goBackToViewController() {
        homeNavController.popViewController(animated: true)
    }
}
