//
//  GameFieldView.swift
//  VIews
//
//  Created by Timur Saidov on 08/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

@IBDesignable
class GameFieldView: UIView {
    
    
    // MARK: Public Properties
    
    @IBInspectable var shapeColor: UIColor = .red { // Аннотация @IBInspectable для того, чтобы св-во отображалось в палитре св-в элемента.
        didSet {
            setNeedsDisplay() // При изменении св-в GameFieldView вызывается метод draw(_ rect: CGRect) определенный ниже.
        }
    }
    @IBInspectable var shapePosition: CGPoint = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapeSize: CGSize = CGSize(width: 40, height: 40) {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var isShapeHidden = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    // MARK: Public Properties
    
    var shapeHitHandler: (() -> ())?
    
    
    // MARK: Private Properties
    
    private var curPath: UIBezierPath?
    
    
    // MARK: Lifecycle
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard !isShapeHidden else {
            curPath = nil
            return
        }
        shapeColor.setFill()
        let path = getTrianglePath(in: CGRect(origin: shapePosition, size: shapeSize))
        path.fill()
        curPath = path
    }
    
    
    // MARK: Overriding
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let curPath = curPath else { return }
        let hit = touches.contains { touch -> Bool in
            let touchPoint = touch.location(in: self)
            return curPath.contains(touchPoint)
        }
        if hit {
            shapeHitHandler?()
        }
    }
    
    
    // MARK: Public
    
    func randomizeShapes() {
        let maxX = bounds.maxX - shapeSize.width
        let maxY = bounds.maxY - shapeSize.height
        let x = CGFloat(arc4random_uniform(UInt32(maxX)))
        let y = CGFloat(arc4random_uniform(UInt32(maxY)))
        shapePosition = CGPoint(x: x, y: y)
    }
    
    
    // MARK: Private
    
    private func getTrianglePath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 0
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.close()
        path.stroke()
        path.fill()
        return path
    }
}
