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

class LoginViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let viewModel: LoginViewModel
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    weak var delegate: LoginViewControllerDelegate?
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        let allUsers = viewModel.retrieveAllUsers()

        for user in allUsers {
            print("Name: \(user.name)")
            print("Birthdate: \(user.birthdate)")
            print("Email: \(user.email)")
            print("Password: \(user.password)")
            print("-----------")
        }
    }
    
    private func setupCollectionView() {
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: "LoginCell")
        collectionView.register(SignUpCell.self, forCellWithReuseIdentifier: "SignUpCell")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pin(to: view)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfOptions
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoginCell", for: indexPath) as! LoginCell
            cell.configure {
                self.viewModel.email = cell.emailTextField.text
                self.viewModel.password = cell.passwordTextField.text
                self.handleLoginOrSignIn(for: .login)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SignUpCell", for: indexPath) as! SignUpCell
            cell.configure {
                self.viewModel.name = cell.nameTextField.text
                self.viewModel.email = cell.emailTextField.text
                self.viewModel.password = cell.passwordTextField.text
                self.viewModel.birthdate = cell.birthdatePicker.date
                self.handleLoginOrSignIn(for: .signUp)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    private func handleLoginOrSignIn(for option: LoginOption) {
        switch option {
        case .login:
            if viewModel.loginUser() {
                guard let email = viewModel.email else { return }
                delegate?.loginViewControllerNeedToGoHome(self, withEmail: email)
            } else {
                showError(viewModel.loginErrorMessage)
            }
        case .signUp:
            if viewModel.createUser() {
                print("Sign-Up successful")
                guard let email = viewModel.email else { return }
                delegate?.loginViewControllerNeedToGoHome(self, withEmail: email)
            } else {
                showError(viewModel.signUpErrorMessage)
            }
        }
    }

    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    
}
