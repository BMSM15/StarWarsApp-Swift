//
//  Species.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 18/07/2024.
//

import Foundation

struct Species: Codable {
    let name: String
    let language: String
    let people: [String]
    let url: String
    var id: String {
        Services.getID(from: url)
    }
}
