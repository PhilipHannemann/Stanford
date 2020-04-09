//
//  DeckView.swift
//  Set
//
//  Created by Philip Hannemann on 31.03.20.
//  Copyright © 2020 HashTech. All rights reserved.
//

import UIKit

class DeckView: UIView {

    var cardCount:Int = 0 {
        didSet {
            addCard()
        }
    }
    
    private var imageViews = [UIImageView]()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    func addCard(){

        if let image = UIImage(named: "CardBG") {
            let imageView = UIImageView(image: image)
            
            if let superView = self.superview {
                var offset = 0.0
                for index in 0..<cardCount{
                    if index > cardCount-2{
                        offset += 4
                    }
                    
                    imageView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: bounds.height * 0.8, height: bounds.height * 0.8 * 5.0/3.0)
                    
                    imageView.transform = CGAffineTransform.identity
                        .rotated(by: -CGFloat.pi/2)
                        .translatedBy(x: imageView.frame.height/2, y: imageView.frame.width/2)
                        .translatedBy(x: -bounds.height/2 + offset.cgFloat, y: offset.cgFloat)
                    
                    superView.addSubview(imageView)
                    imageViews.append(imageView)
                }
            }
        }
    }
    

}
