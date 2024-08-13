//
//  User.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 31/07/2024.
//

import Foundation

struct User: Codable {
    let imageURL: String
    let name: String
    let birthdate: String
    let videoURL: String
    let images: [String]
    let links: [Link]
}

struct Link: Codable {
    let title: String
    let url: String
    let openMode: LinkOpenMode
}

enum LinkOpenMode: String, Codable {
    case `internal` = "INTERNAL"
    case modal = "MODAL"
    case external = "EXTERNAL"
}
