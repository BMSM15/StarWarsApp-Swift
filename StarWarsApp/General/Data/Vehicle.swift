//
//  Vehicle.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 18/07/2024.
//

import Foundation

struct Vehicle: Codable {
    let name: String
    let pilots: [String]
    let url: String
    var id: String {
        Services.getID(from: url)
    }
}
