//
//  SettingsViewModel.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 30/07/2024.
//

import Foundation

struct Section {
    let title: String?
    let items: [SectionItem]
}

enum SectionItem {
    case profileImage(url: URL)
    case nameAndAge(name : String, age: Int)
    case video(url : URL)
    case image(URL)
    case link(Link)
}

struct Naming {
    let names: [String]
}

class SettingsViewModel {
    
    // MARK: - Variables
    
    var user: User?
    var sections: [Section] = []
    
    // MARK: - Fetch Data
    
    func fetchSettings(completion: @escaping () -> Void) {
        guard let url = Bundle.main.url(forResource: "profile", withExtension: "json") else {
            print("Failed to locate profile.json in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            self.user = try decoder.decode(User.self, from: data)
                        
            
            if let imageURL = user?.imageURL, let url = URL(string: imageURL) {
                let profileImageSection = Section(title: nil, items: [.profileImage(url: url)])
                sections.append(profileImageSection)
            }
            
            if let user = user,
               let age = calculateAge(from: user.birthdate) {
                let nameAndAgeSection = Section(title: "User Data", items: [.nameAndAge(name: user.name, age: age)])
                sections.append(nameAndAgeSection)
            }
            
            if let videoURL = user?.videoURL, let url = URL(string: videoURL) {
                let videoSection = Section(title: nil, items: [.video(url: url)])
                sections.append(videoSection)
            }
            
            if let images = user?.images {
                let arrayImages: [SectionItem] = images.compactMap {
                    if let url = URL(string: $0) {
                        return .image(url)
                    } else {
                        return nil
                    }
                }
                if !arrayImages.isEmpty {
                    sections.append(Section(title: "Gallery", items: arrayImages))
                }
            }

            if let links = user?.links {
                let arrayLinks: [SectionItem] = links.map {
                    return .link($0)
                }
                sections.append(Section(title: "Links", items: arrayLinks))
            }
            
                completion()
            } catch {
                print("Failed to decode profile.json: \(error.localizedDescription)")
            }
        }
        
        // MARK: - Functions
        
        func calculateAge(from birthdateString: String) -> Int? {
            let formatter = DateFormatter.shortDate
            guard let birthdate = formatter.date(from: birthdateString) else {
                return nil
            }
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
    
