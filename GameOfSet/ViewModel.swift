//
//  ViewModel.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import SwiftUI

class SetViewModel: ObservableObject {
    
    typealias Card = GameModel.Card
    
    @Published private var game = GameModel()
    
    var inGameCards: [Card] {
        game.inGameCards
    }
    
    var deckIsEmpty: Bool {
        game.deckIsEmpty
    }
    
    func chooseCard(_ card: Card) {
        game.chooseCard(card)
    }
    
    func addCards() {
//        print("------------------------")
        game.addCards()
    }
    
    func newGame() {
        game = GameModel()
    }
}
