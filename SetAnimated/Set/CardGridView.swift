//
//  CardGridView.swift
//  Set
//
//  Created by Philip Hannemann on 24.03.20.
//  Copyright © 2020 HashTech. All rights reserved.
//

import UIKit

class CardGridView: UIView {

    var cards:[CardView] = [CardView]()

    var cardHasBeenSelected:(_ sender:CardView)->Void = {_ in }
    
    func addCard(){
        let newCard = CardView()
        cards.append(newCard)
        addSubview(newCard)
        setNeedsLayout()
    }
    
    func deleteCards(){
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    func setCards(_ cards:[CardView]){
        deleteCards()
        self.cards = cards
        for card in cards {
            addSubview(card)
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // reposition my subviews’s frames based on my new bounds
        layOut()
    }
    
    
    func layOut(){
        let dx = Double(bounds.width)
        let dy = Double(bounds.height)

        let factorX = dx/CardView.ratioX
        let factorY = dy/CardView.ratioY
        let factorXFirst = factorY/factorX
        let factorYFirst = factorX/factorY
        
        let xFirst = fitCards(for: factorXFirst)
        let yFirst = fitCards(for: factorYFirst)
        
        var dimentions:(x:Int, y:Int) = xFirst
        if xFirst.0 * xFirst.1 > yFirst.0 * yFirst.1 {
            dimentions.x = yFirst.1
            dimentions.y = yFirst.0
        }
        
        arrange(for: dimentions)
    }
    
    func fitCards(for factorY:Double)->(Int, Int){
        var factorX = 0.0
        
        var maxCardCount = 0
        var yCount = 0
        while maxCardCount < cards.count{
            factorX += 1
            yCount = Int(factorX*factorY)
            
            maxCardCount = yCount * Int(factorX)
        }
        
        return (Int(factorX), yCount)
    }
    
    
    func arrange(for dimentions:(x:Int, y:Int)) {
        let dx = Double(bounds.width) / Double(dimentions.x)
        let dy = Double(bounds.height) / Double(dimentions.y)
        
        let xFac = dx/CardView.ratioX
        let yFac = dy/CardView.ratioY
        
        var width = dx
        var height = dy
        
        if xFac > yFac {
            width = height/CardView.ratioY * CardView.ratioX
        }else{
            height = width/CardView.ratioX * CardView.ratioY
        }

        if cards.count == 0{
            return
        }
        var index = 0
        
        for y in 0..<dimentions.y{
            for x in 0..<dimentions.x{
                
                let origin = CGPoint(x: dx * Double(x), y: dy * Double(y))
                cards[index].frame.origin = origin
                cards[index].frame.size = CGSize(width: width, height: height)
                
                index += 1
                if index >= cards.count {
                    return
                }
            }
        }
    }
    
    
    
}
