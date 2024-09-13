//
//  OnBoardingViewModel.swift
//  StarWarsApp
//
//  Created by Bruno Martins on 19/08/2024.
//

import Foundation

class OnBoardingViewModel {
    
    // MARK: - Variables
    
    private var cards: [OnBoardingCard] = []
    
    // MARK: - Initialization
    
    init() {
        loadOnboardingDataFromJSON()
    }
    
    // MARK: - Actions
    
    private func loadOnboardingDataFromJSON() {
        if let path = Bundle.main.path(forResource: "onboarding", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let onboardingData = try JSONDecoder().decode(OnBoardingData.self, from: data)
                self.cards = onboardingData.cards
            } catch {
                print("Erro ao carregar o JSON: \(error)")
            }
        }
    }
    
    var numberOfCards: Int {
        return cards.count
    }
    
    func card(at index: Int) -> OnBoardingCard {
        return cards[index]
    }

    func isLastCard(at index: Int) -> Bool {
        return index == cards.count - 1
    }
    
}
