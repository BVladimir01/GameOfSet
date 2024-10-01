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
                        var areMatched = false
                        for (i, delay) in [0, 0, 0.15, 0.3].enumerated() {
                            withAnimation(.easeInOut.delay(delay)) {
                                if i == 0 {
                                    areMatched = viewModel.chooseCard(card)
                                } else {
                                    if areMatched {
                                        viewModel.addCard()
                                    }
                                }
                            }
                        }
                    }
                    .matchedGeometryEffect(id: card.id, in: cardsView)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }

            
            HStack {
                if viewModel.deckIsEmpty { Rectangle().foregroundStyle(.clear).frame(width: 100, height: 150)}
                CardDeckView(viewModel.inDeckCards, aspectRatio: 2 / 3, gameId: viewModel.gameId) { card in
                    CardView(card)
                        .matchedGeometryEffect(id: card.id, in: cardsView, isSource: true)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                        .onTapGesture {
                            for delay in [0, 0.15, 0.3] {
                                withAnimation(.easeInOut.delay(delay)) {
                                    viewModel.addCard()
                                }
                            }
                        }
                }
                .frame(width: 80, height: 120)
                Spacer()
                CardDeckView(viewModel.outOfGameCards, aspectRatio: 2 / 3, gameId: viewModel.gameId) { card in
                    CardView(card)
                        .matchedGeometryEffect(id: card.id, in: cardsView)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                }
                .frame(width: 80, height: 120)
//                .zIndex(0)
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.white)
                        .strokeBorder(lineWidth: 3)
                        .frame(width: 80, height: 120)
                    Button("New\nGame") { viewModel.newGame() }
                        .font(.title)
                        .foregroundColor(.teal)
                }
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
