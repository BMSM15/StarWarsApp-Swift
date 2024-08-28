//
//  LoginViewModel.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 21/08/2024.
//

import Foundation
import Security

class LoginViewModel {
    
    private(set) var isLoginView: Bool = true
    
    var email: String?
    var password: String?
    var name: String?
    var birthdate: Date?
    
    var loginErrorMessage: String = ""
    var signUpErrorMessage: String = ""
    
    var numberOfOptions: Int {
        return 2 
    }
    
    func toggleLoginSignUp() {
        isLoginView.toggle()
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return email.isValidEmail
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.isValidPassword
    }
    
    func isValidName(_ name: String) -> Bool {
        return name.isValidName
    }
    
    func createUser() -> Bool {
        guard let name = name, isValidEmail(name) else {
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
    
    func getUserByEmail(_ email: String) -> UserLogin? {
        return KeychainHelper.shared.loadUser(email: email)
    }
    
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
    
    func retrieveAllUsers() -> [UserLogin] {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: kCFBooleanTrue,
            kSecMatchLimit: kSecMatchLimitAll
        ] as [String: Any]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess, let dataArray = dataTypeRef as? [Data] else {
            return []
        }
        
        var users = [UserLogin]()
        
        for data in dataArray {
            if let jsonString = String(data: data, encoding: .utf8),
               let user = UserLogin.from(jsonString: jsonString) {
                users.append(user)
            }
        }
        
        return users
    }
    
}
