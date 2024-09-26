//
//  ViewModel.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import SwiftUI

class SetViewModel: ObservableObject {
    
//    for simplicity
    typealias Card = GameModel.Card
    
//    model variable
    @Published private var game = GameModel()
    
//    allows access for view to read ingame cards
    var inGameCards: [Card] {
        game.inGameCards
    }
//    allows acces for view to check deck
    var deckIsEmpty: Bool {
        game.deckIsEmpty
    }
    
//    delegates intent from view to model
//    delegates card choosing
    func chooseCard(_ card: Card) {
        game.chooseCard(card)
    }
//    delegates card addition
    func addCards() {
        game.addCards()
    }
    
//    starts new game
    func newGame() {
        game = GameModel()
    }
}
