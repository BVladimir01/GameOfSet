//
//  Model.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import Foundation


struct GameModel: Equatable, Identifiable {
    
    var id: Int
    
//    global copy of starting deck for every game
    private static let allCards: [Card] = generateAllCards()
    
//    func that generates it
    private static func generateAllCards() -> [Card] {
        var res: [Card] = []
        for _ in 0..<81 {
            res.append(Card())
        }
        return res
    }
    
//    every card of the game
    private var allCards: [Card] = GameModel.allCards
    
//    cards that are in the deck, sorted by drawing order
    var inDeckCards: [Card] {
        allCards.filter { $0.state == .inDeck }
            .sorted { $0.drawOrder < $1.drawOrder }
    }
    
//    cards that are on the tavble, sorted by draw order
    var inGameCards: [Card] {
        allCards.filter { $0.state == .inGame }
            .sorted { $0.drawOrder < $1.drawOrder }
    }
    
//    cards, chosen by the player, that are on the table
    var chosenCards: [Card] {
        inGameCards.filter { $0.isChosen }
    }
    
//    cards that went out of the game
    var outOfGameCards: [Card]  = []
    
//    bool property ot check end of the deck
    var deckIsEmpty: Bool {
        inDeckCards.isEmpty
    }
    
//    func that handles choosing new card
//    return true if cards were matched and removed
    mutating func chooseCard(_ card: Card) -> Bool {
        let index = card.id
        var res = false
        
        if chosenCards.count == 3 {
            let indicies = chosenCards.map { $0.id }
            if chosenCards.allSatisfy({$0.isMatched == .matched }) {
                for index in indicies {
                    allCards[index].state = .outOfGame
                    outOfGameCards.append(allCards[index])
                }
//                addCards()
            res = true
            } else {
                for index in indicies {
                    allCards[index].isChosen = false
                    allCards[index].isMatched = .nonMatched
                }
            }
            allCards[index].isChosen = true
            return res
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
        return res
    }
    
//    func that handles matching, when choosing a card
    private mutating func onMatch() {
        while !chosenCards.isEmpty {
            let card = chosenCards[0]
            let index = card.id
            allCards[index].isChosen = false
            allCards[index].state = .outOfGame
        }
        addCards()
    }
    
//    func that handles false matching, when choosing a card
    private mutating func onNonMatch() {
        while !chosenCards.isEmpty {
            let card = chosenCards[0]
            let index = card.id
            allCards[index].isChosen = false
        }
    }
    
//    func that add 3cards from the deck to ingamecards
    mutating func addCards() {
        if chosenCards.count == 3 {
            let indicies = chosenCards.map { $0.id }
            if chosenCards.allSatisfy({$0.isMatched == .matched }) {
                for index in indicies { allCards[index].state = .outOfGame }
            }
        }
        if !deckIsEmpty {
            for (i, card) in inDeckCards.enumerated() {
                allCards[card.id].state = .inGame
                if i == 2 { break }
            }
        }
    }
    
//    adds single card
    mutating func addCard() {
        if chosenCards.count == 3 {
            let indicies = chosenCards.map { $0.id }
            if chosenCards.allSatisfy({$0.isMatched == .matched }) {
                for index in indicies { allCards[index].state = .outOfGame }
            }
        }
        if let card = inDeckCards.first {
            allCards[card.id].state = .inGame
        }
    }
    
    mutating func shuffle() {
        let count = allCards.count
        for (id, drawOrder) in ((0..<count).shuffled()).enumerated() {
            allCards[id].drawOrder = drawOrder
        }
    }
    
    mutating func flushCards() {
        for card in inGameCards {
            outOfGameCards.append(card)
            allCards[card.id].state = .outOfGame
        }
    }
    
    mutating func shuffleCards() {
        let count = allCards.count
        for (id, drawOrder) in ((0..<count).shuffled()).enumerated() {
            allCards[id].state = .inDeck
            allCards[id].drawOrder = drawOrder
        }
        outOfGameCards = []
    }
    
    mutating func dealCards() {
        id += 1
        let count = allCards.count
        for id in 0..<count {
            allCards[id].state = allCards[id].drawOrder < 12 ? .inGame : .inDeck
            allCards[id].isMatched = .nonMatched
            allCards[id].isChosen = false
        }
    }
    
    
    mutating func newGame() {
        shuffle()
        id += 1
        let count = allCards.count
        for id in 0..<count {
            allCards[id].state = allCards[id].drawOrder < 12 ? .inGame : .inDeck
            allCards[id].isMatched = .nonMatched
            allCards[id].isChosen = false
        }
        outOfGameCards = []
    }
    
//    Card structure
    struct Card: Identifiable, Equatable {
        
//        cards basic properties
        let shape: FieldOfThree
        let color: FieldOfThree
        let texture: FieldOfThree
        let count: FieldOfThree
        
//        cards state in the game
        var state: CardState = .inDeck
        var isChosen: Bool = false
        var isMatched: MatchState = .nonMatched
        
//        cards id and drawing order
        let id: Int
        var drawOrder: Int = 0
        
//        static counter for assigning ids
        private static var cardCount = 0
        
//        checks if every property is zero
//        helps in matching cards
        private var isZeroCard: Bool {
            if (shape == .zero) && (color == .zero) && (texture == .zero) && (count == .zero) { return true }
            return false
        }
//        overloading card addition to ease matching
        static func +(lhs: Card, rhs: Card) -> Card {
            return Card(shape: lhs.shape + rhs.shape, color: lhs.color + rhs.color, texture: lhs.texture + rhs.texture, count: lhs.count + rhs.count)
        }
//        match checker
        static func areMatched(_ cards: [Card]) -> Bool {
            assert(cards.count == 3, "invalid number for match")
            return (cards[0] + cards[1] + cards[2]).isZeroCard
        }

//        init that allows to set every nondefault property
        init(shape: FieldOfThree, color: FieldOfThree, texture: FieldOfThree, count: FieldOfThree) {
            self.shape = shape
            self.color = color
            self.texture = texture
            self.count = count
            self.id = shape.rawValue + color.rawValue * 3 + texture.rawValue * 8 + count.rawValue * 27
        }
//        auto init
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
        
        //debug init
        init(shape: FieldOfThree, color: FieldOfThree, texture: FieldOfThree, count: FieldOfThree, state: CardState, isChosen: Bool, isMatched: MatchState, id: Int, drawOrder: Int) {
            self.shape = shape
            self.color = color
            self.texture = texture
            self.count = count
            self.state = state
            self.isChosen = isChosen
            self.isMatched = isMatched
            self.id = id
            self.drawOrder = drawOrder
        }
        
//        enum of cardstate
        enum CardState {
            case inGame, inDeck, outOfGame
        }
//        enum of match state
        enum MatchState {
            case matched, nonMatched, falslyMatched
        }
        
        
        
        
    }
    
    
//    game initializer
//    randomizes draw order
    init() {
        assert(GameModel.allCards.count == 81, "Wrong number of cards")
        for (i, j) in ((0..<81)).enumerated() {
            allCards[i].drawOrder = j
            if j < 12 { allCards[i].state = .inGame }
        }
        id = GameModel.numGames
        GameModel.numGames += 1
    }
    
    static var numGames = 0
}

// Finite field of three enumeration with operation of addition
enum FieldOfThree: Int, CaseIterable {
    case zero = 0, one, two
    
    static func +(lhs: FieldOfThree, rhs: FieldOfThree) -> FieldOfThree{
        let newIntValue = (lhs.rawValue + rhs.rawValue) % 3
        assert([0, 1, 2].contains(newIntValue), "Invalid new value of FielfOfThree")
        return FieldOfThree(rawValue: newIntValue)!
    }
}
