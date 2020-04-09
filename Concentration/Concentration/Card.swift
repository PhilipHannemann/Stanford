//
//  Card.swift
//  Concentration
//
//  Created by Philip Hannemann on 24.01.20.
//  Copyright © 2020 HashTech. All rights reserved.
//

import Foundation


struct Card : Hashable {
    var isFaceUp = false
    var isMatched = false
    var identifier:Int
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func hash(into: inout Hasher){
        into.combine(identifier)
    }
    
    private static var identifierFactory = 0
    
    private static func getNewIdentifier()->Int{
        identifierFactory += 1
        return identifierFactory
    }
    
    
    init() {
        identifier = Card.getNewIdentifier()
    }
}
