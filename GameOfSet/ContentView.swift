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
    
    @Namespace var cardsView
    
    //    view body
    var body: some View {
        VStack {
            BestView(viewModel.inGameCards,
                     aspectRatio: 2 / 3,
                     minItems: Constants.minItemsInARow,
                     maxItems: Constants.maxItemsInARow) { card in
                CardView(card)
                    .padding(Constants.cardPadding)
                    .onTapGesture {
                        withAnimation {
                            viewModel.chooseCard(card)
                        }
                    }
                    .matchedGeometryEffect(id: card.id, in: cardsView)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
//                    .zIndex(0)
            }
            //            .animation(.default, value: viewModel.inGameCards)
            HStack {
                if viewModel.deckIsEmpty { Rectangle().foregroundStyle(.clear).frame(width: 100, height: 150)}
                CardDeckView(viewModel.inDeckCards, aspectRatio: 2 / 3) { card in
                    CardView(card)
                        .matchedGeometryEffect(id: card.id, in: cardsView, isSource: true)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                viewModel.addCards()
                            }
                        }
                }
                .frame(width: 80, height: 120)
                Spacer()
                CardDeckView(viewModel.outOfGameCards, aspectRatio: 2 / 3) { card in
                    CardView(card)
                        .matchedGeometryEffect(id: card.id, in: cardsView)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                }
                .frame(width: 80, height: 120)
                Spacer()
                Button("New Game") { viewModel.newGame() }
//                    .font(.title)
//                    .foregroundColor(.teal)
            }
            .padding()
        }
    }
    //    contentview constants
    private struct Constants {
        static let aspectRatio = CGFloat(2 / 3)
        static let cardPadding = CGFloat(2)
        static let maxItemsInARow = 6
        static let minItemsInARow = 3
    }
}

#Preview {
    ContentView()
}
