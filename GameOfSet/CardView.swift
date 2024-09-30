//
//  CardView.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import SwiftUI

struct CardView: View {
    
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
        let verticalOffsetPercentage = card.isMatched == .matched ? -0.15 : 0
        let horizontalOFfsetPercentage = card.isMatched == .falslyMatched ? 0.01 : 0
        
        MultipleShapeBuilder(count: card.count,
                             shape:card.shape,
                             padding: Constants.shapePadding)
        .fill(color.opacity(opacity))
        .stroke(Color(color), lineWidth: Constants.shapeBorderWidth)
        .padding(Constants.shapeViewPadding)
        .cardify(borderColor: borderColor, state: card.state)
        .bouncing(offsetPercentage: verticalOffsetPercentage, trigger: card.isMatched == .matched)
        .shaking(offsetPercentage: horizontalOFfsetPercentage, numBounces: 3, damping: 0.8, trigger: card.isMatched == .falslyMatched, duration: 0.2)        
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
    }
    
//    cardview constants
    private struct Constants {
        static let shapeBorderWidth = CGFloat(2)
        static let shapeViewPadding = CGFloat(5)
        static let shapePadding = CGFloat(5)
    }
}

#Preview {
    CardView(GameModel.Card(shape: .two, color: .one, texture: .one, count: .two))
        .padding(20)
}

extension View {
    func cardify(borderColor: Color, state: GameModel.Card.CardState) -> some View {
        self.modifier(Cardify(borderColor: borderColor, state: state))
    }
}


extension View {
    func bouncing(offsetPercentage: Double,
                  numBounces: Int = 3,
                  damping: Double = 0.5,
                  trigger: some Equatable,
                  duration: TimeInterval = 1) -> some View {
        return GeometryReader(content: { geometry in
            let animationDuration = duration  / Double(2 * numBounces)
            var coords: [CGFloat] = [CGFloat(0)]
            for i in 0..<numBounces {
                coords.append(CGFloat(geometry.size.height * offsetPercentage * pow(CGFloat(damping), CGFloat(i)) ))
                coords.append(CGFloat(0))
            }
            
            return self.phaseAnimator(coords, trigger: trigger) {content, coord in
                content.offset(x: 0, y: coord)
            } animation: { coord in
                coord == CGFloat(0) ? .easeIn(duration: animationDuration) : .easeOut(duration: animationDuration)
            }
        })
    }
    
    func shaking(offsetPercentage: Double,
                  numBounces: Int = 3,
                  damping: Double = 0.5,
                  trigger: some Equatable,
                  duration: TimeInterval = 1) -> some View {
        return GeometryReader(content: { geometry in
            let duration = duration / Double(2 * numBounces)
            var coords: [CGFloat] = [CGFloat(0)]
            for i in 0..<numBounces {
                coords.append(CGFloat(geometry.size.width * offsetPercentage * pow(CGFloat(damping), CGFloat(i))))
                coords.append(-CGFloat(geometry.size.width * offsetPercentage * pow(CGFloat(damping), CGFloat(i))))
            }
            
            return self.phaseAnimator(coords, trigger: trigger) {content, coord in
                content.offset(x: coord, y: 0)
            } animation: { coord in
                    .linear(duration: duration)
            }
        })
    }
}
