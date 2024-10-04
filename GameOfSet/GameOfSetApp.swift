//
//  GameOfSetApp.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import SwiftUI


@main
struct GameOfSetApp: App {
    typealias Card = GameModel.Card
    var card1 = Card(shape: .zero, color: .zero, texture: .zero, count: .zero, state: .inGame, isChosen: false, isMatched: .nonMatched, id: 0, drawOrder: 0)

    var card2 = Card(shape: .zero, color: .zero, texture: .zero, count: .zero, state: .inDeck, isChosen: false, isMatched: .nonMatched, id: 0, drawOrder: 0)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            TestContentView(card1: card1, card2: card2)
//            CardView(GameModel.Card(shape: .two, color: .one, texture: .one, count: .two))
//                .padding(20)
        }
    }
}
