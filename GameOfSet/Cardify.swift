//
//  Cardify.swift
//  GameOfSet
//
//  Created by Vladimir on 26.09.2024.
//

import SwiftUI

// Modifier that puts content into card with given border color
struct Cardify: ViewModifier, Animatable {
    
    init(borderColor: Color, state: GameModel.Card.CardState) {
        angle =  (state == .inGame) ? .zero : .degrees(180)
        self.borderColor = borderColor
        self.state = state
    }
    
    var animatableData: Angle {
        get { angle }
        set { angle = newValue }
    }
    
    var angle: Angle
    let borderColor: Color
    let state: GameModel.Card.CardState
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .fill(.white)
                .strokeBorder(lineWidth: Constants.cardBorderWidth)
                .foregroundStyle(borderColor)
            content
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .fill(.teal)
                .strokeBorder(lineWidth: Constants.cardBorderWidth)
                .foregroundStyle(.black)
                .opacity(state == .inGame ? 0 : 1)
        }
        .rotation3DEffect(angle, axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/
        )
        
    }
    
    private struct Constants {
        static let cardCornerRadius = CGFloat(10)
        static let cardBorderWidth = CGFloat(3)
        static let scaleFactor = 1.5
    }
}
