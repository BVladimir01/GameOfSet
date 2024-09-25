//
//  Model.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import Foundation


struct GameModel: Equatable {
    
    static let allCards: [Card] = generateAllCards()
    
    private static func generateAllCards() -> [Card] {
        var res: [Card] = []
        for _ in 0..<81 {
            res.append(Card())
        }
        return res
    }
    
    var allCards: [Card] = GameModel.allCards
    
    var inDeckCards: [Card] {
        allCards.filter { $0.state == .inDeck }
            .sorted { $0.drawOrder < $1.drawOrder }
    }
    
    var inGameCards: [Card] {
        allCards.filter { $0.state == .inGame }
            .sorted { $0.drawOrder < $1.drawOrder }
    }
    
    var chosenCards: [Card] {
        inGameCards.filter { $0.isChosen }
    }
    
    var outOfGameCards: [Card] {
        allCards.filter { $0.state == .outOfGame }
    }
    
    var deckIsEmpty: Bool {
        inDeckCards.isEmpty
    }
    
    mutating func chooseCard(_ card: Card) {
        print("\(card.id)")
        print("-----------------")
        let index = card.id
        
        if chosenCards.count == 3 {
            let indicies = chosenCards.map { $0.id }
            if chosenCards.allSatisfy({$0.isMatched == .matched }) {
                for index in indicies { allCards[index].state = .outOfGame }
                addCards()
            } else {
                for index in indicies {
                    allCards[index].isChosen = false
                    allCards[index].isMatched = .nonMatched
                }
            }
            allCards[index].isChosen = true
            return
        }
        
        if allCards[index].isChosen { allCards[index].isChosen = false}
        else { allCards[index].isChosen = true}
        
        if chosenCards.count == 3 {
            let indicies = chosenCards.map { $0.id }
            if Card.areMatched(chosenCards) {
                for index in indicies { allCards[index].isMatched = .matched }
            } else {
                for index in indicies { allCards[index].isMatched = .falslyMatched }
            }
            
        }
    }
    
    mutating func onMatch() {
        while !chosenCards.isEmpty {
            let card = chosenCards[0]
            let index = card.id
            allCards[index].isChosen = false
            allCards[index].state = .outOfGame
        }
        addCards()
    }
    
    mutating func onNonMatch() {
        while !chosenCards.isEmpty {
            let card = chosenCards[0]
            let index = card.id
            allCards[index].isChosen = false
        }
    }
    
    mutating func addCards() {
        if chosenCards.count == 3 {
            let indicies = chosenCards.map { $0.id }
            if chosenCards.allSatisfy({$0.isMatched == .matched }) {
                for index in indicies { allCards[index].state = .outOfGame }
                addCards()
            }
//            else {
//                for index in indicies {
//                    allCards[index].isChosen = false
//                    allCards[index].isMatched = .nonMatched
//                }
//            }
        }
        
        if !deckIsEmpty {
            for (i, card) in inDeckCards.enumerated() {
                allCards[card.id].state = .inGame
//                print(card.id)
//                print(card.drawOrder)
//                print("-----------------")
                if i == 2 { break }
            }
            
//            for (i, card) in inDeckCards.enumerated() {
//                allCards[card.id].state = .inGame
//                if i == 3 { break }
//            }
        }
    }

    struct Card: Identifiable, Equatable {
        
        let shape: FieldOfThree
        let color: FieldOfThree
        let texture: FieldOfThree
        let count: FieldOfThree
        let id: Int
        var drawOrder: Int = 0
        
        private static var cardCount = 0
        
        private var isZeroCard: Bool {
            if (shape == .zero) && (color == .zero) && (texture == .zero) && (count == .zero) { return true }
            return false
        }
        
        var state: CardState = .inDeck
        var isChosen: Bool = false
        var isMatched: MatchState = .nonMatched
        
        init(shape: FieldOfThree, color: FieldOfThree, texture: FieldOfThree, count: FieldOfThree) {
            self.shape = shape
            self.color = color
            self.texture = texture
            self.count = count
            self.id = shape.rawValue + color.rawValue * 3 + texture.rawValue * 8 + count.rawValue * 27
        }
        
        init () {
            var ternaryStr = String(Card.cardCount, radix: 3)
            let shape = ternaryStr.popLast() ?? "0"
            let color = ternaryStr.popLast() ?? "0"
            let texture = ternaryStr.popLast() ?? "0"
            let count = ternaryStr.popLast() ?? "0"
            self.shape = FieldOfThree(rawValue: Int(String(shape))!)!
            self.color = FieldOfThree(rawValue: Int(String(color))!)!
            self.texture = FieldOfThree(rawValue: Int(String(texture))!)!
            self.count = FieldOfThree(rawValue: Int(String(count))!)!
            self.id = Card.cardCount
            Card.cardCount += 1
        }
        
        static func +(lhs: Card, rhs: Card) -> Card {
            return Card(shape: lhs.shape + rhs.shape, color: lhs.color + rhs.color, texture: lhs.texture + rhs.texture, count: lhs.count + rhs.count)
        }
        
        static func areMatched(card1: Card, card2: Card, card3: Card) -> Bool {
            (card1 + card2 + card3).isZeroCard
        }
        
        static func areMatched(_ cards: [Card]) -> Bool {
            assert(cards.count == 3, "invalid number for match")
            return areMatched(card1: cards[0], card2: cards[1], card3: cards[2])
        }
    }
    
    enum CardState {
        case inGame, inDeck, outOfGame
    }
    
    enum MatchState {
        case matched, nonMatched, falslyMatched
    }
    
    init() {
        assert(GameModel.allCards.count == 81, "Wrong number of cards")
        for (i, j) in ((0..<81).shuffled()).enumerated() {
            allCards[i].drawOrder = j
            if j < 12 { allCards[i].state = .inGame }
            
//            allCards[i].drawOrder = i
//            if i < 12 { allCards[i].state = .inGame }
        }
        
    }
}


enum FieldOfThree: Int, CaseIterable {
    case zero = 0, one, two
    
    static func +(lhs: FieldOfThree, rhs: FieldOfThree) -> FieldOfThree{
        let newIntValue = (lhs.rawValue + rhs.rawValue) % 3
        assert([0, 1, 2].contains(newIntValue), "Invalid new value of FielfOfThree")
        return FieldOfThree(rawValue: newIntValue)!
    }
}
