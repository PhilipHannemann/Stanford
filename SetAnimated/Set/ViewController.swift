//
//  ViewController.swift
//  Set
//
//  Created by Philip Hannemann on 21.03.20.
//  Copyright © 2020 HashTech. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    let game = SetGame()
    
    override func viewDidLoad() {
        //makeAllCardsTransparent()
        super.viewDidLoad()
        
        updateViewFromModel()
    }
    
    @IBOutlet weak var heading: UILabel!
    
    @IBOutlet weak var cardGridView: CardGridView!{
        didSet{
            cardGridView.cardHasBeenSelected = selectCard
        }
    }
    @IBOutlet weak var deckPlaceholder: DeckView! {
        didSet{
            deckPlaceholder.cardCount = game.deck.count
        }
    }
    
    @IBOutlet weak var moreOrNewButton: UIButton!
    var matchedSet = false
    var gameDone = false
    
    func selectCard(_ sender: CardView) {
        
        game.cardSelected(with: sender.cardID)
        
        updateViewFromModel()
        
        if game.isDone(){
            moreOrNewButton.setTitle("New Game!", for: UIControl.State.normal)
            gameDone = true
        }
    }
    
    
    @IBAction func dealMoreCards(_ sender: UIButton) {
        if gameDone{
            gameDone = false
            game.reset()
            updateViewFromModel()
            moreOrNewButton.setTitle("Deal 3 More Cards", for: UIControl.State.normal)
        }else{
            getMoreCards()
        }
    }
    
    func getMoreCards(){

        game.getThreeMoreCards()

        updateViewFromModel()
    }
    
    
    func updateViewFromModel(){
        var cards = [CardView]()
        var id = 0
        for card in game.presentedCards{
            
            let cardView = CardView()
            
            cardView.fillNumber = card.features[0]
            cardView.shapeCount = card.features[1]
            cardView.shapeColorNumber = card.features[2]
            cardView.shapeNumber = card.features[3]
            
            cardView.isSelcted = card.isSelected
            cardView.isMarked = card.isMarked
            
            cardView.cardID = id
            
            cards.append(cardView)
            id += 1
        }
        
        cardGridView?.setCards(cards)
    }
    
}


extension Int{
    
    var int8:Int8 {
        return Int8(self)
    }
}

extension Double{
    
    var cgFloat:CGFloat {
        return CGFloat(self)
    }
}
