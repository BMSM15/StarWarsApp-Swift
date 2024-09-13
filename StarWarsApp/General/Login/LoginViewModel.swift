//
//  LoginViewModel.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 21/08/2024.
//

import Foundation
import Security

class LoginViewModel {
    
    // MARK: - Variables
    

    var email: String?
    var password: String?
    var name: String?
    var birthdate: Date?
    var loginErrorMessage: String = ""
    
    // MARK: - Validation
    
    func isValidEmail(_ email: String) -> Bool {
        return email.isValidEmail
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.isValidPassword
    }
    
    func isValidName(_ name: String) -> Bool {
        return name.isValidName
    }
    
    // MARK: - User Login
    
    func loginUser() -> Bool {
        guard let email = email, isValidEmail(email),
              let password = password, isValidPassword(password) else {
            loginErrorMessage = "Invalid email or password"
            return false
        }
        
        if let user = KeychainHelper.shared.loadUser(email: email), user.password == password {
            return true
        } else {
            loginErrorMessage = "Email or password is incorrect"
            return false
        }
    }
    
}
