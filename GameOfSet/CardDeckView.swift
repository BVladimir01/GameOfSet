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
    
    //    init
    init(_ cards: [Card], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Card) -> ItemView) {
        self.cards = cards
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        if cards.count > 0 {
            ZStack {
                ForEach(cards) { card in
//                    let intencity = Double(cards.firstIndex(of: card)!) / Double(cards.count)
                    let intencity = 1.0
                    let coordAmp = 10.0
                    let angleAmp = 5.0
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
        let x = obj.hashValue
        let y = 0.hashValue ^ x
        let z = 1.hashValue ^ x
        let max = Double(Int.max)
        
        return (Double(x) / max, Double(y) / max, Double(z) / max)
    }
    
//    func offsetRandomizer(_ card: Card, intencity: Double) -> CGFloat {
//        let amplitude = 15.0 * intencity
//        let sign = Double(Bool.random() ? +1 : -1)
//        return sign * CGFloat.random(in: 0...15 * intencity)
//    }
//    
//    
//    func angleRadomizer(_ card: Card, intencity: Double) -> Angle {
//        let amplitude = 5.0 * intencity
//        let sign = Double(Bool.random() ? +1 : -1)
//        let angle = Double.random(in: 0...5 * intencity)
//        return .degrees(angle * sign)
//    }
}


//struct CardDeckView: View {
//
//    typealias Card = GameModel.Card
//    
//    //    items to build view for
//        var cards: [Card]
//    //    aspect ratio for views
//        var aspectRatio: CGFloat = 1
//    //    func that builds views from items
//        @ViewBuilder var content: (Card) -> some View
//        
//        var maxItems: CGFloat
//        var minItems: CGFloat
//        
//    //    init
//        init(_ cards: [Card], aspectRatio: CGFloat, minItems: Int, maxItems: Int, @ViewBuilder content: @escaping (Card) -> ItemView) {
//            self.cards = cards
//            self.aspectRatio = aspectRatio
//            self.content = content
//        }
//    
//    
//    var body: some View {
//        if cards.count > 0 {
//            ZStack {
//                ForEach(cards.reversed()) { card in
//                    content(card)
////                    let intencity = abs(Double(card.drawOrder) - Double(cards.last!.drawOrder)) / Double(cards.count)
////                    CardView(card)
////                        .cardify(borderColor: .black, state: card.state)
////                        .offset(x: offsetRandomizer(intencity: intencity),
////                                y: offsetRandomizer(intencity: intencity))
//                        .offset(x: Constants.offsets[card.drawOrder].x,
//                                y: Constants.offsets[card.drawOrder].y)
////                        .rotationEffect(angleRadomizer(intencity: intencity))
//                        .rotationEffect(Constants.angles[card.drawOrder])
//                }
//            }
//        }
//    }
//    
//    static func offsetRandomizer(intencity: Double) -> CGFloat {
//        let sign = Double(Bool.random() ? +1 : -1)
//        return sign * CGFloat.random(in: 0...15*intencity)
//    }
//    
//    static func generateOffsets() -> [(x: CGFloat,y: CGFloat)] {
//        var res: [(CGFloat, CGFloat)] = []
//        for i in 0..<81 {
//            let x = offsetRandomizer(intencity: Double(i)/81)
//            let y = offsetRandomizer(intencity: Double(i)/81)
//            res.append((x: x, y: y))
//        }
//        return res
//    }
//    
//    static func angleRadomizer(intencity: Double) -> Angle {
//        let sign = Double(Bool.random() ? +1 : -1)
//        let angle = Double.random(in: 0...5 * intencity)
//        return .degrees(angle * sign)
//    }
//    
//    static func generateAngles() -> [Angle] {
//        var res: [Angle] = []
//        for i in 0..<81 {
//            res.append(angleRadomizer(intencity: Double(i)/81))
//        }
//        return res
//    }
//    struct Constants {
//        static let offsets = CardDeckView.generateOffsets()
//        static let angles = CardDeckView.generateAngles()
//    }
//}
//
//let game = GameModel()
//#Preview {
//    CardDeckView(cards: game.inDeckCards).padding().frame(width: 200, height: 300)
//}
//

