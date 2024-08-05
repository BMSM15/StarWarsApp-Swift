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
        
        settingsViewController.delegate = self
        viewController.delegate = self
        
        self.configureNavigationController(homeNavController, title: "Home", image: UIImage(systemName: "house"), viewController: viewController)
        self.configureNavigationController(settingsNavController, title: "Settings", image: UIImage(systemName: "person"), viewController: settingsViewController)
        self.setViewControllers([homeNavController, settingsNavController], animated: true)
    }
    
    private func configureNavigationController(_ navigationController: UINavigationController, title: String, image: UIImage?, viewController: UIViewController) {
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension TabBarController: ViewControllerDelegate {
    func viewController(_ viewController: ViewController, needsOpenDetailsForCharacter person: Person) {
        print("needsOpenDetailsForCharacter")
        let detailsViewModel = DetailsViewModel(person: person, services: services)
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel)
        detailsViewController.delegate = self
        homeNavController.pushViewController(detailsViewController, animated: true)
    }
    
}

extension TabBarController: DetailsViewControllerDelegate {
    func detailsViewControllerNeedsToGoBack() {
        homeNavController.popViewController(animated: true)
    }
}

extension TabBarController: SettingsViewControllerDelegate {
    func settingsviewController(_ viewController: SettingsViewController, needsToOpenLink link: Link) {
        guard let url = URL(string: link.url) else {
            let alert = UIAlertController(
                title: "Invalid URL",
                message: "Try again later!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default,
                handler: { _ in
                    self.selectedIndex = 0
                }
            ))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let webViewModel = WebViewModel(url: url)
        let webViewController = WebViewController(viewModel: webViewModel)
        webViewController.delegate = self
        
        switch link.openMode {
        case .internal: // Adjust this case if you have an enum
            settingsNavController.pushViewController(webViewController, animated: true)
        case .modal: // Adjust this case if you have an enum
            present(webViewController, animated: true, completion: nil)
        case .external: // Adjust this case if you have an enum
            UIApplication.shared.open(url)
        }
    }
}


extension TabBarController : WebViewControllerDelegate {
    
    func webViewControllerNeedsToGoBack(_ viewController: WebViewController) {
        self.settingsNavController.popViewController(animated: true)
    }
}


//    func intSettingsviewController(_ viewController: UIViewController,_ url: URL) {
//        let webViewModel = WebViewModel(url: url)
//        let webViewController = WebViewController(viewModel: webViewModel)
//        settingsNavController.pushViewController(webViewController, animated: true)
//    }
//
//    func modSettingsviewController(_ viewController: UIViewController, _ url: URL) {
//        let webViewModel = WebViewModel(url: url)
//        let webViewController = WebViewController(viewModel: webViewModel)
//        webNavController.setViewControllers([webViewController], animated: false)
//        present(webNavController, animated: true, completion: nil)
//    }

