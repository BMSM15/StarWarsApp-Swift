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

extension TabBarController : SettingsViewControllerDelegate {
    func settingsviewController(_ viewController: SettingsViewController, needsToOpenLink link: Link) {
        let url = URL(string: link.url)
        let webViewModel = WebViewModel(url: url!)
        let webViewController = WebViewController(viewModel: webViewModel)
        switch link.openMode {
        case "INTERNAL":
            settingsNavController.pushViewController(webViewController, animated: true)
        case "MODAL":
            present(webViewController, animated: true, completion: nil)
        case "EXTERNAL":
            UIApplication.shared.open(url!)
        default:
            return
        }
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
    
