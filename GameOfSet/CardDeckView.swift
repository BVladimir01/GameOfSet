//
//  CardDeckView.swift
//  GameOfSet
//
//  Created by Vladimir on 30.09.2024.
//

import SwiftUI


struct CardDeckView<ItemView: View>: View  {
    
    typealias Card = GameModel.Card
    
    //    items to build view for
    var cards: [Card]
    //    aspect ratio for views
    var aspectRatio: CGFloat = 2 / 3
    //    func that builds views from items
    var content: (Card) -> ItemView
    
    var gameId: Int
    
    //    init
    init(_ cards: [Card], aspectRatio: CGFloat, gameId: Int, @ViewBuilder content: @escaping (Card) -> ItemView) {
        self.cards = cards
        self.aspectRatio = aspectRatio
        self.content = content
        self.gameId = gameId
    }
    
    var body: some View {
        if cards.count > 0 {
            ZStack {
                ForEach(cards) { card in
                    //                    let intencity = Double(cards.firstIndex(of: card)!) / Double(cards.count)
                    let intencity = Constants().intenicty
                    let coordAmp = Constants().coordAmplitude
                    let angleAmp = Constants().angleAmplitude
                    let randomTripple = randomTrippleFloat(for: card.id)
                    content(card)
                        .offset(x: CGFloat(randomTripple.x * coordAmp * intencity),
                                y: CGFloat(randomTripple.y * coordAmp * intencity))
                        .rotationEffect(.degrees(randomTripple.angle * angleAmp * intencity))
                }
            }
        }
    }
    
    func randomTrippleFloat(for obj: any Hashable) -> (x: Double, y: Double, angle: Double) {
        let x = obj.hashValue ^ gameId.hashValue
        let y = 0.hashValue ^ x
        let z = 1.hashValue ^ x
        let max = Double(Int.max)
        
        return (Double(x) / max, Double(y) / max, Double(z) / max)
    }
    
    struct Constants {
        let intenicty = 1.0
        let coordAmplitude = 10.0
        let angleAmplitude = 5.0
    }
}
