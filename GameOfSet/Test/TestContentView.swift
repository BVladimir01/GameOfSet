//
//  TestContentView.swift
//  GameOfSet
//
//  Created by Vladimir on 03.10.2024.
//

import SwiftUI

typealias Card = GameModel.Card
var card1 = Card(shape: .zero, color: .zero, texture: .zero, count: .zero, state: .inGame, isChosen: false, isMatched: .nonMatched, id: 0, drawOrder: 0)

var card2 = Card(shape: .zero, color: .zero, texture: .zero, count: .zero, state: .inDeck, isChosen: false, isMatched: .nonMatched, id: 0, drawOrder: 0)

struct TestContentView: View {
    
    @State var show = true
    var card1: Card
    var card2: Card
    
    @Namespace var name
    
    var body: some View {
        VStack {
            VStack {
                if show {
                    ZStack {
                        CardView(card1)
                            .matchedGeometryEffect(id: card1.id, in: name)
                            .frame(width: 100, height: 150)
                    }
                    .transition(.rotateCard(card: card1))
                    .transition(.asymmetric(insertion: .rotateCard(card: card1), removal: .rotateCard(card: card1)))
                }
                Spacer()
                if !show {
                    ZStack {
                        CardView(card2)
                            .matchedGeometryEffect(id: card2.id, in: name)
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 150)
                    }
                    .transition(.asymmetric(insertion: .rotateCard(card: card2), removal: .rotateCard(card: card2)))
                }
            }
            .padding()
            Spacer()
            Button("text") {
                withAnimation(.easeInOut) {
                    show.toggle()
                    //            print(card1)
                    //            print(card2)
                }
            }
            .font(.largeTitle)
        }
    }
    
    
}

#Preview {
    TestContentView(card1: card1, card2: card2)
}
