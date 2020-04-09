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
        var isSelected = false
        var isMarked:Bool?
        
        init(features:[Int]) {
            self.features = features
        }
        init() {
            self.features = [0, 0, 0, 0]
        }
        static func == (lhs: Card, rhs: Card) -> Bool {
            return lhs.features == rhs.features
        }
    }
    
    private(set) var deck = [Card]()
    private(set) var presentedCards = [Card]()
    private(set) var selectedCards = [Int]()

    
    
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
    
    func cardSelected(with index:Int){
        resetMarked()
        let selectedCard = presentedCards[index]
        presentedCards[index].isSelected = !selectedCard.isSelected
        if selectedCard.isSelected {
            selectedCards.removeAll(where: {$0 == index})
        }else{
            selectedCards.append(index)
        }
        
        if selectedCards.count == 3 {
            var cards = [Card]()
            for index in selectedCards{
                cards.append(presentedCards[index])
            }
            if !matchCards(cards){
                for index in selectedCards{
                    presentedCards[index].isMarked = false
                }
            }
            for index in selectedCards{
                presentedCards[index].isSelected = false
            }
            selectedCards = []
        }
    }
    
    func resetMarked(){
        for index in presentedCards.indices{
            presentedCards[index].isMarked = nil
        }
    }
    
    func matchCards(_ cards:[Card], deletion:Bool = true)->Bool {
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
        
        if deletion {
            if deck.count != 0{
                for index in presentedCards.indices{
                    if(cards.contains(presentedCards[index])){
                        presentedCards[index] = deck.popLast() ?? Card()
                    }
                }
            }else{
                presentedCards.removeAll(where: {cards.contains($0)})
                selectedCards = []
            }
        }
        
        return true
    }
    
    func getThreeMoreCards(){
        for _ in 0..<3{
            if let card = deck.popLast(){
                presentedCards.append(card)
            }
        }
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
                    
                    let match = matchCards([firstCard, secondCard, thirdCard], deletion: false)
                    
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
