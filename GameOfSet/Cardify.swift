//
//  Cardify.swift
//  GameOfSet
//
//  Created by Vladimir on 26.09.2024.
//

import SwiftUI

// Modifier that puts content into card with given border color
struct Cardify: ViewModifier {
    
//    border color
    let borderColor: Color
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .fill(.white)
                .strokeBorder(lineWidth: Constants.cardBorderWidth)
                .foregroundStyle(borderColor)
            content
        }
    }
    
    private struct Constants {
        static let cardCornerRadius = CGFloat(10)
        static let cardBorderWidth = CGFloat(3)
    }
}
