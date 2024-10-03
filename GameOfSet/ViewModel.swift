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

//    allows access for view to read out of game cards
    var outOfGameCards: [Card] {
        game.outOfGameCards
    }
    
//    allows view to access deck cards
    var inDeckCards: [Card] {
        game.inDeckCards
    }
    
//    allows acces for view to check deck
    var deckIsEmpty: Bool {
        game.deckIsEmpty
    }
    
    var gameId: Int {
        game.id
    }

    var chosenCards: [Card] {
        game.chosenCards
    }
//    delegates intent from view to model
//    delegates card choosing
    func chooseCard(_ card: Card) -> Bool {
        game.chooseCard(card)
    }
    
//    delegates 3 card addition
    func addCards() {
        game.addCards()
    }
    
//    delegates 3 card addition
    func addCard() {
        game.addCard()
    }
    
//    starts new game
    func newGame() {
//        game = GameModel()
        game.newGame()
    }
    
    struct Constants {
        static let themeColor: Color = .teal
    }
}
