//
//  ContentView.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = SetViewModel()
    
    typealias Card = GameModel.Card
    
    var body: some View {
        VStack {
            
            BestView(viewModel.inGameCards, aspectRatio: 2/3) { card in
                CardView(card)
                    .padding(2)
                    .onTapGesture {
                        viewModel.chooseCard(card)
                    }}
            .animation(.default, value: viewModel.inGameCards)
            HStack {
                if !viewModel.deckIsEmpty {
                    Button("Add 3 Cards") { viewModel.addCards() }
                }
                Spacer()
                Button("New Game") { viewModel.newGame() }
            }
            .font(.title)
            .foregroundColor(.teal)
        }
        .padding()
        
    }
    
    static func viewParametersFromCard(_ card: Card) -> (color: Color, texture: Double, count: Int) {
        
        let color: Color
        switch card.color {
        case .zero:
            color = Color(.orange)
        case .one:
            color = Color(.green)
        case .two:
            color = Color(.blue)
        }
        
        let texture: Double
        switch card.texture {
        case .zero:
            texture = 0
        case .one:
            texture = 0.5
        case .two:
            texture = 1
        }
        
        let count: Int
        switch card.count {
        case .zero:
            count = 1
        case .one:
            count = 2
        case .two:
            count = 3
        }
        
        return (color, texture, count)
    }
    
    
}

#Preview {
    ContentView()
}
