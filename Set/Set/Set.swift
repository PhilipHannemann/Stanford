//
//  Set.swift
//  Set
//
//  Created by Philip Hannemann on 22.03.20.
//  Copyright © 2020 HashTech. All rights reserved.
//

import Foundation

class SetGame {
    
    struct Card : Equatable {
        var features = [Int]()
        
        init(features:[Int]) {
            self.features = features
        }
        static func == (lhs: Card, rhs: Card) -> Bool {
            return lhs.features == rhs.features
        }
    }
    
    private(set) var deck = [Card]()
    private(set) var presentedCards = [Card]()
    
    init() {
        createDeck()
        
        for _ in 0..<12{
            if let card = deck.popLast(){
                presentedCards.append(card)
            }
        }
    }
    
    private func createDeck(){
        deck = []
        for f1 in 1...3{
            for f2 in 1...3{
                for f3 in 1...3{
                    for f4 in 1...3{
                        let card = Card(features: [f1, f2, f3, f4])
                        deck.append(card)
                    }
                }
            }
        }
        deck.shuffle()
    }
    
    func matchCards(for cards:[Card], deltion:Bool = true)->Bool {
        if cards.count != 3{
            return false
        }

        for feature in 0..<4{
            var sum = 0
            for card in cards{
                sum += card.features[feature]
            }
                
            if sum % 3 != 0 {
                return false
            }
        }
        
        if deltion {
            presentedCards.removeAll(where: {cards.contains($0)})
        }
        
        return true
    }
    
    func getThreeMoreCards()->[Card]{
        var cards = [Card]()
        for _ in 0..<3{
            if let card = deck.popLast(){
                presentedCards.append(card)
                cards.append(card)
            }
        }
        
        return cards
    }
    
    func isDone()->Bool{
        
        if deck.count != 0 || presentedCards.count > 12 {
            return false
        }else if presentedCards.count == 0{
            return true
        }
        
        var checkedCards = presentedCards
        
        for index1 in 0..<checkedCards.count-2 {
            let firstCard = checkedCards[index1]
            
            for index2 in index1+1..<checkedCards.count{
                let secondCard = checkedCards[index2]
                
                for index3 in index2+1..<checkedCards.count{
                    let thirdCard = checkedCards[index3]
                    
                    let match = matchCards(for: [firstCard, secondCard, thirdCard], deltion: false)
                    
                    if match {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    func reset(){
        deck = []
        presentedCards = []
        createDeck()
        
        for _ in 0..<12{
            if let card = deck.popLast(){
                presentedCards.append(card)
            }
        }
    }
    
}
