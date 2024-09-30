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
                        withAnimation(.easeInOut) {
                            viewModel.chooseCard(card)
                        }
                    }
                    .matchedGeometryEffect(id: card.id, in: cardsView)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
//                     .zIndex(1)
            //            .animation(.default, value: viewModel.inGameCards)
            HStack {
                if viewModel.deckIsEmpty { Rectangle().foregroundStyle(.clear).frame(width: 100, height: 150)}
                CardDeckView(viewModel.inDeckCards.reversed(), aspectRatio: 2 / 3) { card in
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
                CardDeckView(viewModel.outOfGameCards.reversed(), aspectRatio: 2 / 3) { card in
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
    
//    @ViewBuilder private var deck: some View {
//        let cards: [Card] = viewModel.inDeckCards
//        if cards.count > 0 {
//            ZStack {
//                ForEach(cards.reversed()) { card in
//                    let intencity = Double(cards.firstIndex(of: card)!) / Double(cards.count)
//                    CardView(card)
//                        .offset(x: offsetRandomizer(intencity: intencity),
//                                y: offsetRandomizer(intencity: intencity))
//                        .rotationEffect(angleRadomizer(intencity: intencity))
//                }
//            }
//        }
//    }
//    
//    func offsetRandomizer(intencity: Double) -> CGFloat {
//        let sign = Double(Bool.random() ? +1 : -1)
//        return sign * CGFloat.random(in: 0...15*intencity)
//    }
//    
//    
//    func angleRadomizer(intencity: Double) -> Angle {
//        let sign = Double(Bool.random() ? +1 : -1)
//        let angle = Double.random(in: 0...5 * intencity)
//        return .degrees(angle * sign)
//    }
    
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
