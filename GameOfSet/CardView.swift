//
//  CardView.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import SwiftUI

struct CardView: View {
    
//    simplicity
    typealias Card = ContentView.Card
    
//    single property - copy of card it stores
    let card: Card
    
//    the body of view
    var body: some View {
        ZStack {
            let color = colorChoser()
            let opacity = opacityChoser()
            let borderColor = borderColorChoser()
            
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .fill(.white)
                .strokeBorder(lineWidth: Constants.cardBorderWidth)
                .foregroundStyle(borderColor)
            
            MultipleShapeBuilder(count: card.count,
                                 shape:card.shape,
                                 padding: Constants.shapePadding)
            .fill(color.opacity(opacity))
            .stroke(Color(color), lineWidth: Constants.shapeBorderWidth)
            .padding(Constants.shapeViewPadding)
        }
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
    }
    
//    cardview constants
    private struct Constants {
        static let cardCornerRadius = CGFloat(10)
        static let cardBorderWidth = CGFloat(3)
        static let shapeBorderWidth = CGFloat(2)
        static let shapeViewPadding = CGFloat(5)
        static let shapePadding = CGFloat(5)
    }
    
}

#Preview {
    CardView(GameModel.Card(shape: .two, color: .one, texture: .one, count: .two))
        .padding(20)
}
