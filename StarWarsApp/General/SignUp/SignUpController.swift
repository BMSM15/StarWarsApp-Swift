//
//  SignUpController.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 10/09/2024.
//

import UIKit

protocol SignUpViewControllerDelegate: AnyObject {
    func signUpViewControllerDidSignUp(_ viewController: SignUpViewController, withEmail: String)
}

class SignUpViewController: UIViewController {
    
    // MARK: - Variables
    
    let nameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let birthdatePicker = UIDatePicker()
    let signUpButton: Button = Button()
    let imageView = UIImageView()
    let viewModel: SignUpViewModel
    weak var delegate: SignUpViewControllerDelegate?
    
    // MARK: - Initialization
    
    init(viewModel: SignUpViewModel) {
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
    }
    
    // MARK: - Setup
    
    private func setupView() {
        title = "SignUp"
        
        view.backgroundColor = .white
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(birthdatePicker)
        view.addSubview(signUpButton)
        view.addSubview(imageView)
        
        birthdatePicker.datePickerMode = .date
        signUpButton.setTitle("Sign Up", for: .normal)
        
        nameTextField.setPadding(10)
        nameTextField.placeholder = "Name"
        nameTextField.setPlaceholderTextColor(.white)
        
        emailTextField.setPadding(10)
        emailTextField.placeholder = "Email"
        emailTextField.setPlaceholderTextColor(.white)
        
        passwordTextField.setPadding(10)
        passwordTextField.placeholder = "Password"
        passwordTextField.setPlaceholderTextColor(.white)
    }
    
    private func setupConstraints() {
        imageView.contentMode = .scaleAspectFit
        imageView.pinTop(to: view)
        imageView.image = UIImage(named: "SWIcon")
        imageView.pinBottom(to: view, constant: 400)
        imageView.pinLeading(to: view, constant: 90)
        imageView.pinTrailing(to: view, constant: 90)
    
        nameTextField.centerHorizontally(to: view)
        nameTextField.pinTopToBottom(to: imageView)
        nameTextField.pinTrailing(to: view, constant: 50)
        nameTextField.pinLeading(to: view, constant: 50)
        nameTextField.backgroundColor = .gray
        nameTextField.height(constant: 40)
        nameTextField.layer.cornerRadius = 10
        nameTextField.layer.masksToBounds = true
        
        birthdatePicker.centerHorizontally(to: view)
        birthdatePicker.pinTopToBottom(to: nameTextField, constant: 30)
        birthdatePicker.pinTrailing(to: view, constant: 50)
        birthdatePicker.pinLeading(to: view, constant: 50)
        birthdatePicker.backgroundColor = .gray
        birthdatePicker.height(constant: 40)
        birthdatePicker.layer.cornerRadius = 10
        birthdatePicker.layer.masksToBounds = true
        
        emailTextField.centerHorizontally(to: view)
        emailTextField.pinTopToBottom(to: birthdatePicker, constant: 30)
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
        
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = .gray
        signUpButton.pinTopToBottom(to: passwordTextField, constant: 30)
        signUpButton.pinTrailing(to: view, constant: 150)
        signUpButton.pinLeading(to: view, constant: 150)
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.masksToBounds = true
        
        signUpButton.actionHandler = { [weak self] _ in
            self?.handleSignUp()
        }
    }
    
    // MARK: - Actions
    
    private func handleSignUp() {
        viewModel.name = nameTextField.text
        viewModel.birthdate = birthdatePicker.date
        viewModel.email = emailTextField.text
        viewModel.password = passwordTextField.text
        
        if viewModel.createUser() {
            guard let email = viewModel.email else { return }
            delegate?.signUpViewControllerDidSignUp(self, withEmail: email)
        } else {
            showError(viewModel.signUpErrorMessage)
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
