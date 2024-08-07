//
//  SettingsViewModel.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 30/07/2024.
//

import Foundation

class SettingsViewModel {
    
    //MARK: Variables
    
    var user: User?
    
    //MARK: Fetch Data
    
    func fetchSettings(completion: @escaping () -> Void) {
        guard let url = Bundle.main.url(forResource: "profile", withExtension: "json") else {
            print("Failed to locate profile.json in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            self.user = try decoder.decode(User.self, from: data)
            completion()
        } catch {
            print("Failed to decode profile.json: \(error.localizedDescription)")
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

//MARK: Extensions

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
}

