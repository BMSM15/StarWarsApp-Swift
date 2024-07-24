//
//  CharacterDetails.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 18/07/2024.
//

import Foundation

struct CharacterDetails {
    let name: String
    let gender: String
    let language: String?
    var avatarURL: URL? {
        let name = language?.replacingOccurrences(of: " ", with: "+") ?? "unknown"
        return URL(string: "https://eu.ui-avatars.com/api/?name=\(name)")
    }
    var vehicles: [String]
    
}

