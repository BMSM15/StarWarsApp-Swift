//
//  Species.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 18/07/2024.
//

import Foundation

struct Species: Codable {
    let name: String
    let classification: String
    let designation: String
    let average_height: String
    let skin_colors: String
    let hair_colors: String
    let eye_colors: String
    let average_lifespan: String
    let homeworld: String?
    let language: String
    let people: [String]
    let films: [String]
    let created: String
    let edited: String
    let url: String
}
