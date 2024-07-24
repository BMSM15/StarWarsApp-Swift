//
//  AppDelegate.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 17/07/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let services: Services = .init()
    let navigationController = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
                
        // Cria a ViewController inicial
        let viewModel = ViewModel(services: services)
        let mainViewController = ViewController(viewModel: viewModel) // Substitua pelo nome da sua ViewController
        mainViewController.delegate = self
        navigationController.setViewControllers([mainViewController], animated: true)
        
        // Define o NavigationController como o rootViewController da janela
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
                
        return true
    }
}

// MARK: - ViewControllerDelegate

extension AppDelegate: ViewControllerDelegate {
    
    func viewController(_ viewController: UIViewController, needsOpenDetailsForCharacter person: Person) {
        let detailsViewModel = DetailsViewModel(person: person)
        let detailsViewController = DetailsViewController(viewModel: detailsViewModel)
        let navigationController = UINavigationController(rootViewController: detailsViewController)
        self.navigationController.present(navigationController, animated: true)
    }
}
