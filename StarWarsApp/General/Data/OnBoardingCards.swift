//
//  CardsOnBoarding.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 20/08/2024.
//

struct OnBoardingData: Decodable {
    let cards: [OnBoardingCard]
}

struct OnBoardingCard: Decodable {
    let title: String
    let text: String
    let image: String
}
