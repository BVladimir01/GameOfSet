//
//  Cardify.swift
//  GameOfSet
//
//  Created by Vladimir on 26.09.2024.
//

import SwiftUI

// Modifier that puts content into card with given border color
struct Cardify: ViewModifier {
    
    @Environment(\.cardAngle) var angle: Double
    
    init(borderColor: Color, state: GameModel.Card.CardState) {
        self.borderColor = borderColor
        self.state = state
    }
    
    let borderColor: Color
    let state: GameModel.Card.CardState
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .fill(.white)
                .strokeBorder(lineWidth: Constants.cardBorderWidth)
                .foregroundStyle(borderColor)
                .opacity(angle < 90 ? 1 : 0)
            content
                .opacity(angle < 90 ? 1 : 0)
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .fill(.teal)
                .strokeBorder(lineWidth: Constants.cardBorderWidth)
                .foregroundStyle(.black)
                .opacity(angle < 90 ? 0 : 1)
        }
        .rotation3DEffect(.degrees(angle), axis: (x: 0.0, y: 1.0, z: 0.0))
    }
    
    private struct Constants {
        static let cardCornerRadius = CGFloat(10)
        static let cardBorderWidth = CGFloat(3)
        static let scaleFactor = 1.5
    }
}



extension View {
    func cardify(borderColor: Color, state: GameModel.Card.CardState) -> some View {
        self.modifier(Cardify(borderColor: borderColor, state: state))
    }
}

