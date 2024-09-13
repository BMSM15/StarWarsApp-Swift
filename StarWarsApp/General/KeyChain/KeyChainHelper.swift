//
//  KEyChainHelper.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 22/08/2024.
//

import Foundation
import Security

class KeychainHelper {
    
    static let shared = KeychainHelper()
    
    private let emailKey = "com.starwarsapp.userEmail"
    
    private init() {}
    
    func saveUser(email: String, user: UserLogin) -> Bool {
        guard let userData = user.jsonString else {
            print("Failed to encode user data to JSON string.")
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecValueData as String: userData.data(using: .utf8)!
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("Failed to save user: \(status)")
        }
        
        return status == errSecSuccess
    }
    
    func loadUser(email: String) -> UserLogin? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data, let jsonString = String(data: data, encoding: .utf8) {
                return UserLogin.from(jsonString: jsonString)
            } else {
                print("Failed to convert data to JSON string.")
                return nil
            }
        } else if status == errSecItemNotFound {
            print("User not found for email: \(email)")
            return nil
        } else {
            print("Failed to load user: \(status)")
            return nil
        }
    }
    
    
    func deleteUser(email: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess {
            print("Failed to delete user: \(status)")
        }
        
        return status == errSecSuccess
    }
    
    func loadEmail() -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "userEmail",
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as [String: Any]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else {
            print("Error loading email from Keychain: \(status)")
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func userExists(email: String) -> Bool {
        return loadUser(email: email) != nil
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

