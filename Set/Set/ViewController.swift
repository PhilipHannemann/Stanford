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
        makeAllCardsTransparent()
        super.viewDidLoad()
        
        setUpCardLayout()
        dealCards()
    }
    
    @IBOutlet var cardStack: [UIButton]!
    var cardValues = [Card?]()
    var selectedCardIndices = [Int]()
    
    @IBOutlet weak var heading: UILabel!
    
    @IBOutlet weak var moreOrNewButton: UIButton!
    var matchedSet = false
    var gameDone = false
    
    @IBAction func selectCard(_ sender: UIButton) {
        
        if let index = cardStack.firstIndex(of: sender), cardValues[index] != nil{
            
            if selectedCardIndices.count == 3 {
                resetSelection()
            }
            heading.text = "Set - \(game.presentedCards.count) + \(game.deck.count) Cards left"
            if matchedSet {
                if nil != selectedCardIndices.firstIndex(of: index) {
                    getMoreCards()
                    matchedSet = false
                    return
                }else{
                    getMoreCards()
                }
            }else if selectedCardIndices.count == 3{
                selectedCardIndices = []
            }
            
            matchedSet = false
            
            let selected = selectedCardIndices.contains(index)
            if selected {
                sender.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                selectedCardIndices.removeAll(where: {$0 == index})
            }else{
                sender.backgroundColor = UIColor.gray
                selectedCardIndices.append(index)
            }
            
            if selectedCardIndices.count == 3{
                var cards = [SetGame.Card]()
                for i in selectedCardIndices {
                    if let card = cardValues[i] {
                         cards.append(card.card)
                    }
                }
                
                let matched = game.matchCards(for: cards)
                
                if matched {
                    for index in selectedCardIndices {
                        cardStack[index].backgroundColor = UIColor.green
                    }
                    matchedSet = true
                }else{
                    for index in selectedCardIndices {
                        cardStack[index].backgroundColor = UIColor.red
                    }
                }
            }
        }
    }
    
    func set(card: Card, to button : UIButton){
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: card.color.withAlphaComponent(card.alpha),
            .strokeWidth : -10,
            .strokeColor : card.color
        ]
        
        var text = ""
        for i in 0..<card.count{
            text += card.shape + (i < card.count - 1 ? "\n" : "")
        }
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        button.setAttributedTitle(attributedText, for: UIControl.State.normal)
        button.layer.borderColor = UIColor.blue.cgColor
        button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        button.isHidden = false
    }
    
    func makeButtonTransparent(button:UIButton){
        button.setAttributedTitle(NSAttributedString(string: "", attributes: [:]), for: UIControl.State.normal)
        button.setTitle("", for: UIControl.State.normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
    
    func makeAllCardsTransparent(){
        for button in cardStack{
            makeButtonTransparent(button: button)
        }
    }
    
    func resetSelection(){
        for index in cardValues.indices{
            if cardValues[index] != nil{
                cardStack[index].backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }else{
                makeButtonTransparent(button: cardStack[index])
            }
        }
    }
    
    func setUpCardLayout(){
        for button in cardStack{
            button.layer.borderWidth = 3.0
            button.layer.cornerRadius = 8.0
        }
    }
    
    func presentedCardCount() -> Int{
        var count = 0
        for card in cardValues{
            if card != nil{
                count += 1
            }
        }
        return count
    }
    
    
    @IBAction func dealMoreCards(_ sender: UIButton) {
        if gameDone{
            gameDone = false
            game.reset()
            selectedCardIndices = []
            dealCards()
            moreOrNewButton.setTitle("Deal 3 More Cards", for: UIControl.State.normal)
        }else{
            getMoreCards()
        }
    }
    
    func getMoreCards(){
        let cardCount = presentedCardCount()
        if cardCount < cardStack.count || matchedSet {
            var cards = game.getThreeMoreCards()
            
            if cards.count == 0{
                deleteMatchedCards()
                if game.isDone(){
                    moreOrNewButton.setTitle("New Game!", for: UIControl.State.normal)
                    gameDone = true
                }
                selectedCardIndices = []
                return
            }
            
            var newCardIndex = 0
            
            if matchedSet {
                for index in selectedCardIndices{
                    cardValues[index] = Card(card: cards[newCardIndex])
                    set(card: cardValues[index]!, to: cardStack[index])
                    newCardIndex += 1
                }
            }else{
                for cardIndex in cardValues.indices {
                    if cardValues[cardIndex] == nil, let card = cards.popLast() {
                        cardValues[cardIndex] = Card(card: card)
                        set(card: Card(card: card), to: cardStack[cardIndex])
                    }
                }
            }
            
            selectedCardIndices = []
        }
    }
    
    func deleteMatchedCards(){
        if matchedSet {
            for index in selectedCardIndices{
                cardValues[index] = nil
                makeButtonTransparent(button: cardStack[index])
            }
        }
    }
    
    func dealCards(){
        cardValues = []
        for index in cardStack.indices {
            if index >= game.presentedCards.count{
                cardValues.append(nil)
                continue
            }
            let card = Card(card: game.presentedCards[index])
            cardValues.append(card)
            
            set(card: card, to: cardStack[index])
        }
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
