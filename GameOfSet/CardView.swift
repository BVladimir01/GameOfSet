//
//  CardView.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import SwiftUI

struct CardView: View {
    
    typealias Card = ContentView.Card
    
    let card: Card
    
    var body: some View {
        ZStack {
            let color = colorChoser()
            let opacity = opacityChoser()
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .strokeBorder(lineWidth: 3)
                .foregroundStyle(borderColorChoser())
            
            MultipleShapeBuilder(count: card.count,
                                 shape:card.shape)
            .fill(color.opacity(opacity))
            .stroke(Color(color), lineWidth: 2)
            .padding(5)
//                Text("\(card.shape.rawValue)\n\(card.color.rawValue)\n\(card.texture.rawValue)\n\(card.count.rawValue)")
            
        }
    }
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
    
    init(_ card: Card) {
        self.card = card
    }
}

#Preview {
    CardView(GameModel.Card(shape: .zero, color: .one, texture: .one, count: .two))
}
