import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let services: Services = .init()
    let tabBarController = TabBarController()
    let loginViewModel = LoginViewModel()
    
    public struct UserDefaultsKeys {
        static let launchCount = "launchCount"
        static let rememberedEmail = "rememberedEmail"
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let launchCount = UserDefaults.standard.integer(forKey: UserDefaultsKeys.launchCount) + 1
        UserDefaults.standard.set(launchCount, forKey: UserDefaultsKeys.launchCount)
        
        print("LaunchCount - \(launchCount)")
        
        // Check if the onboarding screen should be shown
        if shouldShowOnboarding(launchCount: launchCount) {
            let onBoardingViewModel = OnBoardingViewModel()
            let onBoardingViewController = OnBoardingViewController(viewModel: onBoardingViewModel)
            onBoardingViewController.delegate = tabBarController
            window?.rootViewController = onBoardingViewController
        } else {
            let savedEmail = UserDefaults.standard.string(forKey: UserDefaultsKeys.rememberedEmail)
            tabBarController.userEmail = savedEmail
            tabBarController.setupTabs()
            window?.rootViewController = tabBarController
        }
        
        window?.makeKeyAndVisible()
        return true
    }
    
    private func shouldShowOnboarding(launchCount: Int) -> Bool {
        return launchCount % 10 == 0
    }
    
    func switchToTabBarController() {
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
    
    func presentLoginViewController() {
        let loginController = LoginViewController(viewModel: loginViewModel)
        loginController.delegate = tabBarController
        window?.rootViewController = loginController
        window?.makeKeyAndVisible()
    }
}
