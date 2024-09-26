//
//  ContentView.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import SwiftUI

struct ContentView: View {
    
//    viewmodel
    @ObservedObject var viewModel = SetViewModel()
//    simplicity
    typealias Card = GameModel.Card
    
//    view body
    var body: some View {
        VStack {
            BestView(viewModel.inGameCards, aspectRatio: 2 / 3) { card in
                CardView(card)
                    .padding(Constants.cardPadding)
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
    
//    contentview constants
    private struct Constants {
        static let aspectRatio = CGFloat(2 / 3)
        static let cardPadding = CGFloat(2)
    }
}

#Preview {
    ContentView()
}
