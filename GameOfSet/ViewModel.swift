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
    
    var outOfGameCards: [Card] {
        game.outOfGameCards
    }
    
    var inDeckCards: [Card] {
        game.inDeckCards
    }
    
//    allows acces for view to check deck
    var deckIsEmpty: Bool {
        game.deckIsEmpty
    }
    
    var areMatched: Bool {
        return (game.chosenCards.allSatisfy({$0.isMatched == .matched }) && game.chosenCards.count == 3)
    }
//    delegates intent from view to model
//    delegates card choosing
    func chooseCard(_ card: Card) -> Bool {
        game.chooseCard(card)
    }
    
//    delegates card addition
    func addCards() {
        game.addCards()
    }
    
    func addCard() {
        game.addCard()
    }
    
//    starts new game
    func newGame() {
        game = GameModel()
    }
    
    struct Constants {
        static let themeColor: Color = .teal
    }
}
