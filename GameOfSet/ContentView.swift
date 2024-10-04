//
//  ContentView.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import SwiftUI

struct ContentView: View {
    
    //    viewmodel
    @ObservedObject var viewModel: SetViewModel
    
    //    simplicity
    typealias Card = GameModel.Card
    
    @Namespace var cardsView
    
    @State var gameCardsZIndex: Double = 1
    
    
    //    view body
    var body: some View {
        GeometryReader {geometry in
            let safeArea = geometry.size
//            let widthIcnrement = safeArea.width / 6
//            let heightIncrement = safeArea.height / 5
            Grid {
                GridRow {
                    gameCards
                        .gridCellColumns(3)
                        .zIndex(1)
                }
                GridRow {
                    deckCardsV
                    flushCards.zIndex(2)
                    newGameCard
                }
                
            }
        }
        .padding()
    }
    
    private var gameCards: some View {
        BestView(viewModel.inGameCards,
                 aspectRatio: 2 / 3,
                 minItems: Constants.minItemsInARow,
                 maxItems: Constants.maxItemsInARow) { card in
            ZStack {
                CardView(card)
                    .padding(Constants.cardPadding)
                    .onTapGesture {
                        cardTap(on: card)
                    }
                    .matchedGeometryEffect(id: card.id, in: cardsView)
            }
//            .zIndex(Double(card.drawOrder))
            .transition(.asymmetric(insertion: .rotateCard(card: card), removal: .identity))
        }
    }
    
    private var deckCardsV: some View {
        Group {
            if viewModel.deckIsEmpty {
                Rectangle().foregroundStyle(.clear).frame(width: Constants.cardWidth, height: Constants.cardHeight)
            } else {
                CardDeckView(viewModel.inDeckCards.reversed(), aspectRatio: 2 / 3, gameId: viewModel.gameId) { card in
                        CardView(card)
                            .matchedGeometryEffect(id: card.id, in: cardsView)
                }
                .onTapGesture {
                    deckTap()
                }
                .frame(width: Constants.cardWidth, height: Constants.cardHeight)
            }
        }
//        .animation(.easeInOut, value: viewModel.inDeckCards)
        
    }
    
    private var flushCards: some View {
        Group {
            if viewModel.outOfGameCards.isEmpty {
                Rectangle().foregroundStyle(.clear).frame(width: Constants.cardWidth, height: Constants.cardHeight)
            } else {
                CardDeckView(viewModel.outOfGameCards, aspectRatio: 2 / 3, gameId: viewModel.gameId) { card in
                    CardView(card)
                        .matchedGeometryEffect(id: card.id, in: cardsView)
                }
                .frame(width: Constants.cardWidth, height: Constants.cardHeight)
            }
        }
    }
    
    private var newGameCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                .fill(.white)
                .strokeBorder(lineWidth: Constants.cardBorderLineWidth)
                .frame(width: Constants.cardWidth, height: Constants.cardHeight)
            Button("New\nGame") {
//                newGameTap()
                withAnimation(.easeInOut) {
                    viewModel.newGame()
                }
            }
            .font(.title)
            .foregroundColor(.teal)
        }
    }
    
    @State private var deckCards: [Card]
    
    private func cardTap(on card: Card) {
        var areMatched = false
        for (i, delay) in [0, 0, 0 * Constants.dealDelay, 0 * Constants.dealDelay].enumerated() {
            withAnimation(.easeInOut.delay(delay)) {
                if i == 0 {
                    areMatched = viewModel.chooseCard(card)
                } else {
                    if areMatched {
                        viewModel.addCard()
                        deckCards[deckCards.index(before: deckCards.endIndex)].state = .inGame
                        deckCards.remove(at: deckCards.index(before: deckCards.endIndex))
                    }
                }
            }
        }
    }
    
    private func deckTap() {
        for delay in [0 * Constants.dealDelay, 0 * Constants.dealDelay, 0 * Constants.dealDelay] {
            withAnimation(.easeInOut.delay(delay)) {
                viewModel.addCard()
            }
        }
    }
    
    
    private func newGameTap() {
        for (step, delay) in [0, 0.5, 1].enumerated() {
            withAnimation(.easeInOut.delay(delay)) {
                if step == 0 {
                    viewModel.flushCards()
                }
                if step == 1 {
                    viewModel.shuffleCards()
                }
                if step == 2 {
                    viewModel.dealCards()
                }
                //                        deckCards = viewModel.inDeckCards
            }
        }
    }
    
    init() {
        let viewModel = SetViewModel()
        self.viewModel = viewModel
        self.deckCards = viewModel.inDeckCards
    }
    
    
    //    contentview constants
    private struct Constants {
        static let aspectRatio = CGFloat(2 / 3)
        static let cardPadding = CGFloat(2)
        static let maxItemsInARow = 6
        static let minItemsInARow = 3
        static let dealDelay = 0.15
        static let cardCornerRadius = 10.0
        static let cardBorderLineWidth = 3.0
        static let cardHeight = 120.0
        static let cardWidth = 80.0
    }
}

#Preview {
    ContentView()
}
