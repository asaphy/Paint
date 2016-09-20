//
//  PaintViewModel.swift
//  Paint
//
//  Created by Asaph Yuan on 9/19/16.
//  Copyright © 2016 Asaph Yuan. All rights reserved.
//

import Foundation
import UIKit

class PaintViewModel{
    var lastPoint = CGPoint.zero
    var strokeColor = UIColor.black.cgColor
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    let brushWidths = [4, 8, 16, 32]

    func drawLine(fromPoint: CGPoint, toPoint: CGPoint, tempImage: UIImageView, view: UIView){
        // drawing on tempImageView
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            tempImage.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            // draws line from last point to current point
            context.move(to: fromPoint)
            context.addLine(to: toPoint)
            // drawing parameters
            context.setLineCap(.round)
            context.setLineWidth(brushWidth)
            context.setStrokeColor(strokeColor)
            context.setBlendMode(.normal)
            
            // draw the path
            context.strokePath()
            
            // wrap up the drawing context to render the new line into the temporary image view
            tempImage.image = UIGraphicsGetImageFromCurrentImageContext()
            tempImage.alpha = opacity
            UIGraphicsEndImageContext()
        }
    }
    
    func touchBegan(touch: Set<UITouch>, paintView: UIView) {
        swiped = false
        if let touch = touch.first {
            // update the lastPoint so the next touch event will continue where you just left off.
            lastPoint = touch.location(in: paintView)
        }
    }
    
    func touchMoved(touch: Set<UITouch>, tempImage: UIImageView, view: UIView, event: UIEvent?) {
        swiped = true
        if let touch = touch.first {
            let currentPoint = touch.location(in: view)
            drawLine(fromPoint: lastPoint, toPoint: currentPoint, tempImage: tempImage, view: view)
            
            // update the lastPoint so the next touch event will continue where you just left off.
            lastPoint = currentPoint
        }
    }
    
    func touchEnded(touch: Set<UITouch>, tempImage: UIImageView, mainImage: UIImageView, view: UIView, event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLine(fromPoint: lastPoint, toPoint: lastPoint, tempImage: tempImage, view: view)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImage.frame.size)
        mainImage.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .normal, alpha: 1.0)
        tempImage.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .normal, alpha: opacity)
        mainImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImage.image = nil
    }
    
    
}
