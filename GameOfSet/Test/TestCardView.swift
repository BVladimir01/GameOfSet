//
//  TestCardView.swift
//  GameOfSet
//
//  Created by Vladimir on 03.10.2024.
//
import SwiftUI

struct TestCardView: View {
    
    @Namespace var namespace
    
    @State var bounced = false
    
//    simplicity
    typealias Card = ContentView.Card
    
//    single property - copy of card it stores
    let card: Card
    
//    the body of view
    var body: some View {
        let color = colorChoser()
        let opacity = opacityChoser()
        let borderColor = borderColorChoser()
        let verticalOffsetPercentage = card.isMatched == .matched ? Constants.verticalOffset : 0
        let horizontalOFfsetPercentage = card.isMatched == .falslyMatched ? Constants.horizontalOffset : 0
        
        MultipleShapeBuilder(count: card.count,
                             shape:card.shape,
                             padding: Constants.shapePadding)
        .addColorStrokePadding(color: color, opacity: opacity, linewidth: Constants.shapeBorderWidth, padding: Constants.shapeViewPadding)
//        .cardify(borderColor: borderColor, state: card.state)
        .bouncing(offsetPercentage: verticalOffsetPercentage, trigger: card.isMatched == .matched)
        .shaking(offsetPercentage: horizontalOFfsetPercentage, trigger: card.isMatched == .falslyMatched)
    }
    
//    decodes card textrue (opacity)
    func opacityChoser() -> Double{
        switch card.texture {
        case .zero:
            0
        case .one:
            0.5
        case .two:
            1
        }
    }
    
//    interpretes card borderColor
    func borderColorChoser() -> Color {
        if card.state == .inGame {
            switch (card.isChosen, card.isMatched) {
            case (true, .matched):
                return .green
            case (true, .falslyMatched):
                return .red
            case (true, .nonMatched):
                return .yellow
            default:
                return .teal
            }
        } else {
            return .teal
        }
    }
    
//    color decoder
    func colorChoser() -> Color {
        switch card.color {
        case .zero:
                .blue
        case .one:
                .orange
        case .two:
                .green
        }
    }
    
//    init sets the card
    init(_ card: Card) {
        self.card = card
//        print(card.id)
    }
    
//    cardview constants
    private struct Constants {
        static let shapeBorderWidth = CGFloat(2)
        static let shapeViewPadding = CGFloat(5)
        static let shapePadding = CGFloat(5)
        static let verticalOffset = -0.15
        static let horizontalOffset = 0.01
        static let numBounces = 3
        static let damping = 0.8
    }
}

#Preview {
    TestCardView(GameModel.Card(shape: .two, color: .one, texture: .one, count: .two))
        .padding(20)
}
