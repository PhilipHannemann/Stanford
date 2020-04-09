//
//  CardView.swift
//  Set
//
//  Created by Philip Hannemann on 24.03.20.
//  Copyright © 2020 HashTech. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

    static let ratioX = 3.0
    static let ratioY = 5.0
    
    var isFaceUp = true  {didSet{ setNeedsDisplay() }}
    var isSelcted = false {didSet{ setNeedsDisplay() }}
    var isMarked:Bool? {didSet{ setNeedsDisplay() }}
    
    var cardID = 0
    
    @IBInspectable
    var shapeNumber:Int = 1{
        didSet{
            switch shapeNumber {
            case 1: shape = .oval
            case 2: shape = .diamonds
            default: shape = .squiggles
            }
        }
    }
    
    @IBInspectable
    var fillNumber:Int = 1{
        didSet{
            switch fillNumber {
            case 1: fillState = .clear
            case 2: fillState = .striped
            default: fillState = .filled
            }
        }
    }
    
    var shape:Shape = .squiggles  {didSet{ setNeedsDisplay() }}
    
    var fillState:Fill = .striped
    
    @IBInspectable
    var shapeCount:Int = 1  {didSet{ setNeedsDisplay() }}
    
    @IBInspectable
    var shapeColorNumber:Int = 0{
        didSet{
            switch shapeColorNumber {
            case 1: shapeColor = ShapeColor.blue
            case 2: shapeColor = ShapeColor.green
            default: shapeColor = ShapeColor.purple
            }
        }
    }
    
    var shapeColor:UIColor = ShapeColor.blue  {didSet{ setNeedsDisplay() }}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
        layer.cornerRadius = 8.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectCard))
        addGestureRecognizer(tap)
        
    }
    
    @objc func selectCard(_ sender: UITapGestureRecognizer){
        switch sender.state {
        case .ended:
            isSelcted = !isSelcted
            if let cgv = superview as? CardGridView{
                cgv.cardHasBeenSelected(self)
            }
        default: break
        }
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        drawBackgroundShape()
        
        let threeDrawingAreas = getDrawingAreas()
        let twoDrawingAreas = getTwoDrawingAreas()
        
        var drawShape:(CGRect)->Void
        
        switch shape {
        case .oval: drawShape = drawOval(in:)
        case .diamonds: drawShape = drawDiamonds(in:)
        case .squiggles: drawShape = drawSquiggles(in:)
        }
        
        switch shapeCount {
        case 1:
            drawShape(threeDrawingAreas.1)
        case 2:
            drawShape(twoDrawingAreas.0)
            drawShape(twoDrawingAreas.1)
        default:
            drawShape(threeDrawingAreas.0)
            drawShape(threeDrawingAreas.1)
            drawShape(threeDrawingAreas.2)
        }
    }
    
    func drawCircle(in rect:CGRect){
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let maxWidth = rect.height > rect.width ? rect.width : rect.height
        let radius = CGFloat(maxWidth*LayoutConstraints.shapeScaleFactor/2 - LayoutConstraints.boundsOffset)
        let circle = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        
        drawColors(for: circle, rect: rect)
    }
    
    func drawSquare(in rect:CGRect){
        var width = rect.width*LayoutConstraints.shapeScaleFactor
        var height = rect.height*LayoutConstraints.shapeScaleFactor
        
        if width > height {
            width = height
        }else{
            height = width
        }
        
        let x = rect.origin.x + (rect.width - width) / 2.0
        let y = rect.origin.y + (rect.height - height) / 2.0
        
        let rectToDraw = CGRect(x: x, y: y, width: width, height: height)
        let rectPath = UIBezierPath(roundedRect: rectToDraw, cornerRadius: 4)
        
        drawColors(for: rectPath, rect: rect)
    }
    
    func drawTriangle(in rect:CGRect){
        
        var width = rect.width*LayoutConstraints.shapeScaleFactor
        var height = rect.height*LayoutConstraints.shapeScaleFactor
        
        if width > height {
            width = height
        }else{
            height = width
        }
        
        let x = rect.origin.x + (rect.width - width) / 2.0
        let y = rect.origin.y + (rect.height - height) / 2.0
        
        var points = [CGPoint]()
        points.append(CGPoint(x: x, y: y+height))
        points.append(CGPoint(x: x + width/2, y: y))
        points.append(CGPoint(x: x + width, y: y + height))
        
        let trianglePath = UIBezierPath()
       
        trianglePath.addShape(for: points)
        
        drawColors(for: trianglePath, rect: rect)
    }
    
    func drawOval(in rect:CGRect){
        
        let width = rect.width*LayoutConstraints.shapeScaleFactor
        let height = 0.8*rect.height*LayoutConstraints.shapeScaleFactor*0.9
        
        let x = rect.origin.x + (rect.width - width) / 2.0
        let y = rect.origin.y + (rect.height - height) / 2.0
        
        let radius = height / 2.0
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: x + radius, y: y))
        path.addLine(to: CGPoint(x: x + width - radius, y: y))
        path.addArc(withCenter: CGPoint(x:x + width - radius, y: y + height / 2.0), radius: radius, startAngle: 3*CGFloat.pi/2.0, endAngle: CGFloat.pi/2.0, clockwise: true)
        path.addLine(to: CGPoint(x: x + radius, y: y+height))
        path.addArc(withCenter: CGPoint(x:x + radius, y: y + height / 2.0), radius: radius, startAngle: CGFloat.pi/2.0, endAngle: 3*CGFloat.pi/2.0, clockwise: true)
        path.close()
        
        drawColors(for: path, rect: rect)
    }
    
    func drawDiamonds(in rect:CGRect){
        
        let width = rect.width*LayoutConstraints.shapeScaleFactor
        let height = rect.height*LayoutConstraints.shapeScaleFactor
        
        let x = rect.origin.x + (rect.width - width) / 2.0
        let y = rect.origin.y + (rect.height - height) / 2.0
        
        var points = [CGPoint]()
        points.append(CGPoint(x: x, y: y + height/2))
        points.append(CGPoint(x: x + width/2, y: y))
        points.append(CGPoint(x: x + width, y: y + height/2))
        points.append(CGPoint(x: x + width/2, y: y + height))
        
        let path = UIBezierPath()
        
        path.addShape(for: points)
        
        drawColors(for: path, rect: rect)
    }
    
    func drawSquiggles(in rect:CGRect){
        
        let width = rect.width*LayoutConstraints.shapeScaleFactor
        let height = 0.9*rect.height*LayoutConstraints.shapeScaleFactor
        
        let x = rect.origin.x + (rect.width - width) / 2.0
        let y = rect.origin.y + (rect.height - height) / 2.0 + height*0.05
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: x + width*0.1, y: y + height))
        path.addCurve(to: CGPoint(x: x + width*0.37, y: y + height * 0.8), controlPoint1: CGPoint(x: x + width*0.2, y: y + height), controlPoint2: CGPoint(x: x + width*0.27, y: y + height * 0.8))
        path.addCurve(to: CGPoint(x: x + width*0.7, y: y + height * 0.9), controlPoint1: CGPoint(x: x + width*0.47, y: y + height * 0.8), controlPoint2: CGPoint(x: x + width*0.6, y: y + height * 0.9))
        
        path.addCurve(to: CGPoint(x: x + width*0.9, y: y),
                      controlPoint1: CGPoint(x: x + width * 1.2, y: y + height * 0.8),
                      controlPoint2: CGPoint(x: x + width, y: y))
        
        path.addCurve(to: CGPoint(x: x + width*0.63, y: y + height * 0.2), controlPoint1: CGPoint(x: x + width*0.8, y: y), controlPoint2: CGPoint(x: x + width*0.73, y: y + height * 0.2))
        path.addCurve(to: CGPoint(x: x + width*0.3, y: y + height * 0.1), controlPoint1: CGPoint(x: x + width*0.53, y: y + height * 0.2), controlPoint2: CGPoint(x: x + width*0.4, y: y + height * 0.1))
        
        path.addCurve(to: CGPoint(x: x + width*0.1, y: y + height),
                      controlPoint1: CGPoint(x: x - width*0.2, y: y + height * 0.2),
                      controlPoint2: CGPoint(x: x, y: y + height))
        
        
        drawColors(for: path, rect: rect)
    }
    
    
    
    func drawColors(for shape:UIBezierPath, rect:CGRect){
        shapeColor.setFill()
        shapeColor.setStroke()
        shape.lineWidth = rect.width * LayoutConstraints.shapeStrokeWidth
        
        shape.stroke()
        
        switch fillState {
        case .filled:
            shape.fill()
        case .striped:
            striped(for:shape, rect:rect)
        case .clear:
            break
        }
        
    }
    
    func striped(for shape:UIBezierPath, rect:CGRect){
        let context = UIGraphicsGetCurrentContext()
        
        context?.saveGState()
        shape.addClip()
        
        var dx = rect.origin.x
        shape.lineWidth = 0.75
        
        while dx < rect.maxX {
            
            shape.move(to: CGPoint(x: dx, y: rect.minY))
            shape.addLine(to: CGPoint(x: dx, y: rect.maxY))
            
            dx += 4
        }
        
        shape.stroke()
        context?.restoreGState()
    }
    
    
    
    func drawBackgroundShape(){
        let rect = CGRect(x: LayoutConstraints.boundsOffset, y: LayoutConstraints.boundsOffset, width: bounds.size.width - LayoutConstraints.boundsOffset * 2, height: bounds.size.height - LayoutConstraints.boundsOffset * 2)
        
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: LayoutConstraints.cornerRadius)
        
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        if let victoy = isMarked {
            roundedRect.lineWidth = 2
            if victoy{
                 #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).setStroke()
            }else{
                 #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1).setStroke()
            }
        }else if isSelcted{
            #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).setStroke()
            roundedRect.lineWidth = 2
        }
        roundedRect.fill()
        roundedRect.stroke()
    }
    
    func getDrawingAreas()->(CGRect, CGRect, CGRect){
        var rect1 = getThirdOfBounds()
        var rect2 = getThirdOfBounds()
        var rect3 = getThirdOfBounds()
        let offset:CGFloat = 3
        
        rect1.origin.y += offset
        rect2.origin.y += rect2.size.height + offset
        rect3.origin.y += rect3.size.height * 2 + offset
        
        return (rect1, rect2, rect3)
    }
    
    func getTwoDrawingAreas()->(CGRect, CGRect){
        var rect1 = getThirdOfBounds()
        var rect2 = getThirdOfBounds()
        
        let offset:CGFloat = 3
        rect1.origin.y += rect1.size.height / 2 + offset
        rect2.origin.y += rect2.size.height * 1.5 + offset
        
        return (rect1, rect2)
    }
    
    func getThirdOfBounds()->CGRect{
        let width = bounds.size.width
        let height = (bounds.size.height - 6) / 3
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: height))
        return rect
    }
    
    
    enum Shape {
        case oval
        case diamonds
        case squiggles
    }
    
    enum Fill:Int {
        case filled
        case striped
        case clear
    }
    
    struct ShapeColor {
        static let green = #colorLiteral(red: 0.3993424177, green: 0.8582791686, blue: 0.439819932, alpha: 1)
        static let blue = #colorLiteral(red: 0.5261921287, green: 0.5224915147, blue: 0.8458940387, alpha: 1)
        static let purple = #colorLiteral(red: 0.9999167323, green: 0.02239504084, blue: 0.5469320416, alpha: 1)
    }
    
}



extension CardView {
    
    struct LayoutConstraints {
        static let boundsOffset:CGFloat = 5
        static let cornerRadius:CGFloat = 8
        static let shapeScaleFactor:CGFloat = 0.7
        static let shapeStrokeWidth:CGFloat = 0.015
    }
    
    
}

extension Int {
    
    var cgFloat:CGFloat {
        return CGFloat(self)
    }
}


extension UIBezierPath {
    
    func addShape(for points:[CGPoint]){
        if points.count < 2{
           return
        }
        move(to: points[0])
        for index in 1..<points.count {
            addLine(to: points[index])
        }
        
        close()
    }
    
}

extension CGPoint {
    
    static func +(lhs:CGPoint, rhs:CGPoint)->CGPoint{
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs:CGPoint, rhs:CGPoint)->CGPoint{
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func /(lhs:CGPoint, rhs:CGFloat)->CGPoint{
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }
    
}


struct CGLine {
    var point1:CGPoint
    var point2:CGPoint
    
    init(p1:CGPoint, p2:CGPoint) {
        point1 = p1
        point2 = p2
    }
    
    var angle:CGFloat {
        return atan2(dx, dy) - CGFloat.pi / 2
    }
    
    var length:CGFloat {
        return (pow(dx, 2) + pow(dy, 2)).squareRoot()
    }
    
    var dx:CGFloat {
        return point2.x - point1.x
    }
    var dy:CGFloat {
        return point2.y - point1.y
    }
}
