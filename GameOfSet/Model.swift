//
//  Model.swift
//  GameOfSet
//
//  Created by Vladimir on 25.09.2024.
//

import Foundation


struct Game {
    
    static let allCards: [Card] = generateAllCards()
    
    private static func generateAllCards() -> [Card] {
        var res: [Card] = []
        for shape in FieldOfThree.allCases {
            for color in FieldOfThree.allCases {
                for texture in FieldOfThree.allCases {
                    for number in FieldOfThree.allCases {
                        res.append(Card(shape: shape, color: color, texture: texture, count: number))
                    }
                }
            }
        }
        return res
    }
    
    var allCards: [Card] = Game.allCards
    
    var layedOutCards: [Card] {
        allCards.filter { $0.isLayedOut }
    }

    var chosenCards: [Card] {
        layedOutCards.filter { $0.isChosen }
    }
    
    mutating func chooseCard(_ card: Card) {
        let index = findCardIndex(card)
        if card.isChosen {
            allCards[index].isChosen = false
        } else {
            switch chosenCards.count {
            case ...1:
                allCards[index].isChosen = true
            case 2:
                allCards[index].isChosen = true
                if Card.areMatched(chosenCards) { onMatch() }
                else { onNonMatch() }
            default:
                fatalError("wrong number of matched cards")
            }
        }
    }
    
    mutating func onMatch() {
        
    }
    
    mutating func onNonMatch() {
        
    }
    
    private func findCardIndex(_ card: Card) -> Int {
        let index = allCards.firstIndex{ $0.id == card.id }
        return index!
    }
    
    private func findCardIndex(_ cardId: Card.ID) -> Int {
        let index = allCards.firstIndex{ $0.id == cardId }
        return index!
    }
    
    struct Card: Identifiable {
        let shape: FieldOfThree
        let color: FieldOfThree
        let texture: FieldOfThree
        let count: FieldOfThree
        let id: [FieldOfThree]
        
        private var isZeroCard: Bool {
            if (shape == .zero) && (color == .zero) && (texture == .zero) && (count == .zero) { return true }
            return false
        }
        
        var isDrawn: Bool = false
        var isMatched: Bool = false
        var isChosen: Bool = false
        var isLayedOut: Bool {
            isDrawn && !isMatched
        }
        
        init(shape: FieldOfThree, color: FieldOfThree, texture: FieldOfThree, count: FieldOfThree) {
            self.shape = shape
            self.color = color
            self.texture = texture
            self.count = count
            self.id = [shape, color, texture, count]
        }
        
        static func +(lhs: Card, rhs: Card) -> Card {
            return Card(shape: lhs.shape + rhs.shape, color: lhs.color + rhs.color, texture: lhs.texture + rhs.texture, count: lhs.count + rhs.count)
        }
        
        static func areMatched(card1: Card, card2: Card, card3: Card) -> Bool {
            (card1 + card2 + card3).isZeroCard
        }
        
        static func areMatched(_ cards: [Card]) -> Bool {
            precondition(cards.count == 3, "invalid number for match")
            return areMatched(card1: cards[0], card2: cards[1], card3: cards[2])
        }
    }

    enum FieldOfThree: Int, CaseIterable {
        case zero = 0, one, two
        
        static func +(lhs: FieldOfThree, rhs: FieldOfThree) -> FieldOfThree{
            let newIntValue = (lhs.rawValue + rhs.rawValue) % 2
            precondition([0, 1, 2].contains(newIntValue), "Invalid new value of FielfOfThree")
            return FieldOfThree(rawValue: newIntValue)!
        }
    }
}
