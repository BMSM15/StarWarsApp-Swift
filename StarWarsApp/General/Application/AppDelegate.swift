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
    let tabBarController = TabBarController()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        struct UserDefaultsKeys {
            static let launchCount = "launchCount"
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        let launchCount = UserDefaults.standard.integer(forKey: UserDefaultsKeys.launchCount)
        let newLaunchCount = 10//launchCount + 1
        UserDefaults.standard.set(newLaunchCount, forKey: UserDefaultsKeys.launchCount)
        
        if shouldShowOnboarding(launchCount: newLaunchCount) {
            print("\(newLaunchCount)")
            let onBoardingViewModel = OnBoardingViewModel()
            let onBoardingController = OnBoardingViewController(viewModel: onBoardingViewModel)
            onBoardingController.delegate = tabBarController
            onBoardingController.modalPresentationStyle = .fullScreen
            tabBarController.present(onBoardingController, animated: false, completion: nil)
        } else {
            let loginViewModel = LoginViewModel()
            print("\(newLaunchCount)")
            let loginController = LoginViewController(viewModel: loginViewModel)
            loginController.delegate = tabBarController
            loginController.modalPresentationStyle = .fullScreen
            tabBarController.present(loginController, animated: false, completion: nil)
        }
        
        return true
    }
    
    
    private func shouldShowOnboarding(launchCount: Int) -> Bool {
        return launchCount % 10 == 0
    }
}
