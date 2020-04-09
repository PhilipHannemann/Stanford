//
//  Concentration.swift
//  Concentration
//
//  Created by Philip Hannemann on 24.01.20.
//  Copyright © 2020 HashTech. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    var score = 0
    
    var indexOfTheOneAndOnlyFaceUpCard:Int?{
        get{
            return cards.indices.filter{ cards[$0].isFaceUp }.oneAndOnly
        }
        set{
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index:Int) {
        if !cards[index].isMatched {
            if let machedIndex = indexOfTheOneAndOnlyFaceUpCard, machedIndex != index {
                
                if cards[index] == cards[machedIndex]{
                    score += 2
                    cards[index].isMatched = true
                    cards[machedIndex].isMatched = true
                }else{
                    score -= 1
                }
                cards[index].isFaceUp = true
                
            }else{
                indexOfTheOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    func reset(){
        for index in cards.indices{
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
    }
    
    func allMatched()->Bool{
        for card in cards{
            if !card.isMatched{
                return false
            }
        }
        
        return true
    }
    
    init(numberOfPairsOfCards:Int) {
        for _ in 0..<numberOfPairsOfCards{
            let card = Card()
            cards.append(card)
            cards.append(card)
        }
        
        
        cards.shuffle()
    }
    
}


extension Collection {
    var oneAndOnly:Element?{
        return count == 1 ? first : nil
    }
}
