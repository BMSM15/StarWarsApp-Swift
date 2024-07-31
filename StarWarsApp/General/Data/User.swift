//
//  User.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 31/07/2024.
//

import Foundation

struct User<T: Codable>: Codable {
    let name: String
    let imageURL: String
    let birthdate: String
    let videoURL: String
    let links: [T]
}
