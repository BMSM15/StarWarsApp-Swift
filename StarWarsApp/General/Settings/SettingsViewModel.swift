//
//  SettingsViewModel.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 30/07/2024.
//

import Foundation

class SettingsViewModel {
    var user: User?
    
    init() {
        loadProfile()
    }
    
    private func loadProfile() {
        guard let url = Bundle.main.url(forResource: "profile", withExtension: "json") else {
            print("Failed to locate profile.json in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.shortDate)
            self.user = try decoder.decode(User.self, from: data)
        } catch {
            print("Failed to decode profile.json: \(error)")
        }
    }
    
    func calculateAge(from birthdateString: String) -> Int? {
        let formatter = DateFormatter.shortDate
        guard let birthdate = formatter.date(from: birthdateString) else {
            return nil
        }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([ .year ], from: birthdate, to: Date())
        return ageComponents.year
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
}

