//
//  LoginViewController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 21/08/2024.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func loginViewControllerNeedToGoHome(_ viewController: LoginViewController, withEmail email: String)
}

class LoginViewController: UIViewController {
    
    // MARK: - Variables
    
    private let viewModel: LoginViewModel
    weak var delegate: LoginViewControllerDelegate?
    let loginButton: Button = Button()
    let signUpButton: Button = Button()
    var emailTextField = UITextField()
    let passwordTextField = UITextField()
    let imageView = UIImageView()
    private var signUpViewController: SignUpViewController?
    
    // MARK: - Initialization
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        let allUsers = KeychainHelper.shared.retrieveAllUsers()

        for user in allUsers {
            print("Name: \(user.name)")
            print("Birthdate: \(user.birthdate)")
            print("Email: \(user.email)")
            print("Password: \(user.password)")
            print("-----------")
        }
    }
    
    // MARK: - Setup
    
    private func setupView() {
        title = "Login"
        
        view.backgroundColor = .white
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        view.addSubview(imageView)
        
       loginButton.setTitle("Login", for: .normal)
        signUpButton.setTitle("Sign up", for: .normal)
        
        emailTextField.setPadding(10)
        emailTextField.placeholder = "Email"
        emailTextField.setPlaceholderTextColor(.white)
        
        passwordTextField.setPadding(10)
        passwordTextField.placeholder = "Password"
        passwordTextField.setPlaceholderTextColor(.white)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        imageView.contentMode = .scaleAspectFit
        imageView.pinTop(to: view)
        imageView.image = UIImage(named: "SWIcon")
        imageView.pinLeading(to: view, constant: 50)
        imageView.pinTrailing(to: view, constant: 50)
        
        emailTextField.centerHorizontally(to: view)
        emailTextField.pinTopToBottom(to: imageView)
        emailTextField.pinTrailing(to: view, constant: 50)
        emailTextField.pinLeading(to: view, constant: 50)
        emailTextField.backgroundColor = .gray
        emailTextField.height(constant: 40)
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.masksToBounds = true
        emailTextField.autocapitalizationType = .none
        
        passwordTextField.pinTopToBottom(to: emailTextField, constant: 30)
        passwordTextField.pinTrailing(to: view, constant: 50)
        passwordTextField.pinLeading(to: view, constant: 50)
        passwordTextField.backgroundColor = .gray
        passwordTextField.height(constant: 40)
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.masksToBounds = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .gray
        loginButton.pinTopToBottom(to: passwordTextField, constant: 30)
        loginButton.pinTrailing(to: view, constant: 150)
        loginButton.pinLeading(to: view, constant: 150)
        loginButton.layer.cornerRadius = 10
        loginButton.layer.masksToBounds = true
        loginButton.actionHandler = { [weak self] _ in
            self?.handleLogin()
        }
        
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = .gray
        signUpButton.pinTopToBottom(to: loginButton, constant: 20)
        signUpButton.pinTrailing(to: view, constant: 150)
        signUpButton.pinLeading(to: view, constant: 150)
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.masksToBounds = true
        
        signUpButton.actionHandler = { [weak self] _ in
            self?.goSignUpButton()
        }
    }
    
    // MARK: - Button Actions
    
    private func handleLogin() {
        viewModel.email = emailTextField.text
        viewModel.password = passwordTextField.text
        
        if viewModel.loginUser() {
            guard let email = viewModel.email else { return }
            UserDefaults.standard.set(email, forKey: AppDelegate.UserDefaultsKeys.rememberedEmail)
            delegate?.loginViewControllerNeedToGoHome(self, withEmail: email)
        } else {
            showError(viewModel.loginErrorMessage)
        }
    }
    
    func goSignUpButton() {
        let signUpViewModel = SignUpViewModel()
        let signUpViewController = SignUpViewController(viewModel: signUpViewModel)
        
        present(signUpViewController, animated: true, completion: nil)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}



