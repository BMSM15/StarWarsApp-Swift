//
//  SettingsViewModel.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 30/07/2024.
//

import Foundation
import UIKit

struct Section {
    let title: String?
    let items: [SectionItem]
}

enum SectionItem {
    case profileImage(url: URL)
    case nameAndAge(name: String, age: Int)
    case video(url: URL)
    case image(url: URL, width: Int, height: Int)
    case link(Link)
    case logout
}


class SettingsViewModel {
    
    // MARK: - Variables
    
    var user: User?
    var userLogin: UserLogin?
    var sections: [Section] = []
    var email: String

    // Initialize the ViewModel with the email
    init(email: String) {
        self.email = email
    }
    
    // MARK: - Fetch Data
    
    func fetchSettings(completion: @escaping () -> Void) {
        
        // Load user data from Keychain using the retrieved email
        if let loadedUser = KeychainHelper.shared.loadUser(email: email) {
            userLogin = loadedUser
            print("User loaded from Keychain: \(loadedUser)")
        } else {
            print("User not found in Keychain.")
        }
        
        // Fetch the remaining data from `profile.json`
        guard let url = Bundle.main.url(forResource: "profile", withExtension: "json") else {
            print("Failed to locate profile.json in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            self.user = try decoder.decode(User.self, from: data)
            
            // Add the profile image section
            if let imageURL = user?.imageURL, let url = URL(string: imageURL) {
                let profileImageSection = Section(title: nil, items: [.profileImage(url: url)])
                sections.append(profileImageSection)
                print("😨\(url)")
            }
            
            // Use `UserLogin` data for name and age
            if let userLogin = userLogin,
               let age = calculateAge(from: userLogin.birthdate) {
                let nameAndAgeSection = Section(title: "User Data", items: [.nameAndAge(name: userLogin.name, age: age)])
                sections.append(nameAndAgeSection)
                print("😨\(userLogin.name) , \(age)")
            }
            
            // Add the video section
            if let videoURL = user?.videoURL, let url = URL(string: videoURL) {
                let videoSection = Section(title: nil, items: [.video(url: url)])
                sections.append(videoSection)
            }
            
            // Add the gallery images section
            if let images = user?.images {
                let arrayImages: [SectionItem] = images.compactMap { image in
                    guard let url = URL(string: image.url) else { return nil }
                    return .image(url: url, width: image.width, height: image.height)
                }
                if !arrayImages.isEmpty {
                    sections.append(Section(title: "Gallery", items: arrayImages))
                }
            }
            
            // Add the links section
            if let links = user?.links {
                let arrayLinks: [SectionItem] = links.map {
                    return .link($0)
                }
                sections.append(Section(title: "Links", items: arrayLinks))
            }
            
            let logoutSection = Section(title: nil, items: [.logout])
               sections.append(logoutSection)
            
            completion()
        } catch {
            print("Failed to decode profile.json: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Functions
    
    func calculateAge(from birthdate: Date) -> Int? {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthdate, to: Date())
        return ageComponents.year
    }
}

// MARK: - Extensions

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
}

