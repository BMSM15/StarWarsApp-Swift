//
//  SignUpViewModel.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 10/09/2024.
//

import Foundation

class SignUpViewModel {
    
    // MARK: - Variables
    
    var email: String?
    var password: String?
    var name: String?
    var birthdate: Date?
    var loginErrorMessage: String = ""
    var signUpErrorMessage: String = ""
    
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
    
    func getUserByEmail(_ email: String) -> UserLogin? {
        return KeychainHelper.shared.loadUser(email: email)
    }
    
    // MARK: - User Creation
    
    func createUser() -> Bool {
        guard let name = name, isValidName(name) else {
            signUpErrorMessage = "Invalid Name"
            return false
        }
        guard let birthdate = birthdate else {
            signUpErrorMessage = "Birthdate is required"
            return false
        }
        guard let email = email, isValidEmail(email) else {
            signUpErrorMessage = "Invalid email address"
            return false
        }
        guard let password = password, isValidPassword(password) else {
            signUpErrorMessage = "Password does not meet the required criteria"
            return false
        }
        
        if KeychainHelper.shared.userExists(email: email) {
            signUpErrorMessage = "User already exists with this email"
            return false
        }
        
        let userData = UserLogin(name: name, email: email, birthdate: birthdate, password: password)
        return KeychainHelper.shared.saveUser(email: email, user: userData)
    }
    
}
