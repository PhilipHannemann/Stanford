//
//  ViewController.swift
//  Concentration
//
//  Created by Philip Hannemann on 18.01.20.
//  Copyright © 2020 HashTech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        let emojiChoicesHalloween = ["👻", "🎃", "🦇", "😈", "🍭", "🍬", "🍫", "😱", "🕸", "🧟‍♀️", "🧟‍♂️", "🤯"]
        let emojiChoicesSport = ["🚣🏻‍♀️", "🚵‍♀️", "🏊‍♀️", "🚵‍♂️", "🏄‍♀️", "🤽‍♂️", "🏌️‍♂️", "⛹️‍♂️", "🏋️‍♂️", "🏄‍♂️", "🤾‍♀️", "🚴‍♂️"]
        let emojiChoicesFaces = ["😀", "😇", "🤪", "🤓", "😎", "🥳", "🤑", "😬", "🤩", "🥰", "😍", "😜"]
        
        themes.append(Theme(name: "Halloween", backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), cardColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), emojiChoices: emojiChoicesHalloween))
        themes.append(Theme(name: "Sports", backgroundColor: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), cardColor: #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), emojiChoices: emojiChoicesSport))
        themes.append(Theme(name: "Emojis", backgroundColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), cardColor: #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1), emojiChoices: emojiChoicesFaces))
        
        gameThemeIndex = themes.count.arc4random
        
        super.viewDidLoad()
    }

    var gameThemeIndex = 0
    var emojiSet = [String]()
    lazy var game = Concentration(numberOfPairsOfCards: ((cardStack.count+1) / 2))
    var themes = [Theme]()
    var timer:Timer?
    var secondCounter = 0
    
    @IBOutlet var cardStack: [UIButton]!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func touchCard(_ sender: UIButton) {
        
        if let cardIndex = cardStack.firstIndex(of: sender){
            game.chooseCard(at: cardIndex)
            updateViewFromModel()
        }else{
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction func startNewGame(_ sender: UIButton) {
        newGameButton.isHidden = true
        secondCounter = 0
        game.score = 0
        let lastTheme = gameThemeIndex
        
        while gameThemeIndex == lastTheme {
            gameThemeIndex = themes.count.arc4random
        }
        
        updateGameTheme()
        
        stackView.isHidden = false
    }
    
    @objc func prozessTimer() {
        secondCounter += 1
        let gameScore = secondCounter / 4 - game.score
        scoreLabel.text = "Score: \(gameScore)"
    }
    
    func killTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateGameTheme(){
        let teme = themes[gameThemeIndex]
        emojiSet = teme.emojiChoices
        emojis = [Card:String]()
        heading.text = teme.name
        game.reset()
        if timer != nil{
            killTimer()
        }
        timer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(prozessTimer), userInfo: nil, repeats: true)
        updateViewFromModel()
    }
    
    func updateViewFromModel(){
        let allMatched = game.allMatched()
        for index in cardStack!.indices{
            let button = cardStack![index]
            let card = game.cards[index]
            
            if card.isFaceUp && !allMatched{
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = themes[gameThemeIndex].backgroundColor
            }else{
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : themes[gameThemeIndex].cardColor
            }
        }
        if allMatched {
            newGameButton.isHidden = false
            killTimer()
        }
    }
    
    var emojis = [Card:String]()
    
    func emoji(for card:Card) -> String {
        if emojis[card] == nil, emojiSet.count > 0{
            emojis[card] = emojiSet.remove(at: emojiSet.count.arc4random)
        }
        
        return emojis[card] ?? "?"
    }
    
    
}


extension Int{
    var arc4random : Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

struct Theme {
    var name : String
    var backgroundColor : UIColor
    var cardColor : UIColor
    var emojiChoices : [String]
}
