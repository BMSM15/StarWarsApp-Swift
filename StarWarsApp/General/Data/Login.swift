//
//  Login.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 21/08/2024.
//

import Foundation

struct UserLogin: Codable {
    var name: String
    var email: String
    var birthdate: Date
    var password: String
}

enum LoginOption {
    case login
    case signUp
}

extension UserLogin {
    var jsonString: String? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    static func from(jsonString: String) -> UserLogin? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let data = jsonString.data(using: .utf8) else { return nil }
        return try? decoder.decode(UserLogin.self, from: data)
    }
}

extension String {
    
    var isValidName: Bool {
        let nameRegex = "^[A-Za-z ]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let lettersCount = self.filter { $0.isLetter }.count
        return namePredicate.evaluate(with: self) && lettersCount >= 3
    }
    
    var isValidEmail: Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: self)
    }
}
