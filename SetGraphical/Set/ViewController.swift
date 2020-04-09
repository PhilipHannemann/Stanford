//
//  ViewController.swift
//  Set
//
//  Created by Philip Hannemann on 21.03.20.
//  Copyright © 2020 HashTech. All rights reserved.
//

import UIKit

struct CardLayout {
    static let colors:[UIColor] = [#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)]
    static let shapes = ["▲", "●", "■"]
    static let numbers = [1, 2, 3]
    static let alphaValues = [0, 0.20, 1]
}


class ViewController: UIViewController {
    
    struct Card {
        var color : UIColor
        var shape : String
        var count : Int8
        var alpha : CGFloat
        var card : SetGame.Card
        
        init(card : SetGame.Card) {
            color = CardLayout.colors[card.features[0] - 1]
            shape = CardLayout.shapes[card.features[1] - 1]
            count = CardLayout.numbers[card.features[2] - 1].int8
            alpha = CardLayout.alphaValues[card.features[3] - 1].cgFloat
            self.card = card
        }
    }
    
    let game = SetGame()
    
    override func viewDidLoad() {
        //makeAllCardsTransparent()
        super.viewDidLoad()
        
        updateViewFromModel()
    }
    
    @IBOutlet var cardStack: [UIButton]!
    
    @IBOutlet weak var heading: UILabel!
    
    @IBOutlet weak var cardGridView: CardGridView!{
        didSet{
            cardGridView.cardHasBeenSelected = selectCard
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
