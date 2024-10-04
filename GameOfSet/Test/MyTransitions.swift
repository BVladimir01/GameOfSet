//
//  MyTransitions.swift
//  GameOfSet
//
//  Created by Vladimir on 03.10.2024.
//

import SwiftUI

extension AnyTransition {
    static var rotateCard: AnyTransition {
        AnyTransition.modifier(
            active: cardModifier(angle: 180, opacity: 0),
            identity: cardModifier(angle: 0, opacity: 1))
    }
    
    static func rotateCard(card: Card) -> AnyTransition {
        if card.state != .inDeck {
            return AnyTransition.modifier(
                active: cardModifier(angle: 180, opacity: 0),
                identity: cardModifier(angle: 0, opacity: 1))
        } else {
            return AnyTransition.modifier(
                active: cardModifier(angle: 0, opacity: 1),
                identity: cardModifier(angle: 180, opacity: 0))
        }
    }
    
    struct cardModifier: ViewModifier, Animatable {
        var angle: Double
        var opacity: Double
        
        var animatableData: Double {
            get { angle }
            set { angle = newValue }
        }
        
        func body(content: Content) -> some View {
            return content
                .environment(\.cardAngle, angle)
                .opacity(opacity != 0 ? opacity : 1)
        }
    }
}
