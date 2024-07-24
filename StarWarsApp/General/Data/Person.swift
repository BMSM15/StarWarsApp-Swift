//
//  Person.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 18/07/2024.
//

import Foundation

struct Person: Codable {
    let name: String
    let gender: String
    let species: [String]
    var speciesIDs: [String] {
        return species.map {
            Services.getID(from: $0)
        }
    }
    let vehicles: [String]
    var vehiclesIDs: [String] {
        return vehicles.map {
            Services.getID(from: $0)
        }
    }
    let url: String
    var id: String {
        Services.getID(from: url)
    }
}
