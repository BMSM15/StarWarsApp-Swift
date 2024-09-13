//
//  TabBarController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 31/07/2024.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Variables
    
    let services: Services = .init()
    let homeNavController = UINavigationController()
    let settingsNavController = UINavigationController()
    var userEmail: String?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        self.delegate = self
    }
    
    // MARK: - Setup
    
    func setupTabs() {
        let homeViewModel = ViewModel(services: services)
        let viewController = ViewController(viewModel: homeViewModel)
        let settingsViewModel = SettingsViewModel(email: userEmail ?? "")
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

// MARK: - Delegate Extensions

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
    func settingsviewControllerNeedToGoHome(_ viewController: SettingsViewController) {
        self.selectedIndex = 0
    }
    
    func settingsviewController(_ viewController: SettingsViewController, needsToOpenLink link: Link) {
        guard let url = URL(string: link.url) else {
            let alert = UIAlertController(
                title: "Invalid URL",
                message: "Do you want to go home?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "Yes",
                style: .default,
                handler: { _ in
                    self.selectedIndex = 0
                }
            ))
            alert.addAction(UIAlertAction(
                title: "No",
                style: .cancel,
                handler: nil
            ))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let webViewModel = WebViewModel(url: url)
        let webViewController = WebViewController(viewModel: webViewModel)
        webViewController.delegate = self
        
        switch link.openMode {
        case .internal:
            settingsNavController.pushViewController(webViewController, animated: true)
        case .modal:
            present(webViewController, animated: true, completion: nil)
        case .external:
            UIApplication.shared.open(url)
        }
    }
}


extension TabBarController : WebViewControllerDelegate {
    
    func webViewControllerNeedsToGoBack(_ viewController: WebViewController) {
        self.settingsNavController.popViewController(animated: true)
    }
}

extension TabBarController: LoginViewControllerDelegate {
    func loginViewControllerNeedToGoHome(_ viewController: LoginViewController, withEmail email: String) {
        
        // Store the email when the user logs in
        self.userEmail = email
                
        // Pass the email to the SettingsViewModel
        let settingsViewModel = SettingsViewModel(email: email)
                
        // Initialize the SettingsViewController with the updated SettingsViewModel
        let settingsViewController = SettingsViewController(viewModel: settingsViewModel)
        settingsNavController.setViewControllers([settingsViewController], animated: false)
       
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.switchToTabBarController()
        }
    }
}

extension TabBarController: SignUpViewControllerDelegate {
    func signUpViewControllerDidSignUp(_ viewController: SignUpViewController, withEmail: String) {
        viewController.dismiss(animated: false, completion: nil)
    }
    
    
}

extension TabBarController: OnBoardingViewControllerDelegate {
    func onboardingDidFinish(_ controller: OnBoardingViewController) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.presentLoginViewController()
        }
    }
    
}


