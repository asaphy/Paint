//
//  PaintViewModel.swift
//  Paint
//
//  Created by Asaph Yuan on 9/19/16.
//  Copyright © 2016 Asaph Yuan. All rights reserved.
//

import Foundation
import UIKit

// Try to think of a VM an encapsulation of all the unit testable parts of your code
// there are many parts of your current VM that cannot be unit tested because they are UI related
class PaintViewModel{
    var lastPoint = CGPoint.zero
    var strokeColor = UIColor.black.cgColor
    // this isn't initialized to one of the values in your array
    var brushWidth: CGFloat = 10.0
    // what are you doing with opacity?
    var opacity: CGFloat = 1.0
    var swiped = false
    let brushWidths = [4, 8, 16, 32]
    var eraserSelected = false
    
    // drawLine only does UI work, and does not belong in the VM
    func drawLine(fromPoint: CGPoint, toPoint: CGPoint, mainImage: UIImageView, view: UIView){
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            mainImage.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            // draws line from last point to current point
            context.move(to: fromPoint)
            context.addLine(to: toPoint)
            // drawing parameters
            context.setLineCap(.round)
            context.setLineWidth(brushWidth)
            if eraserSelected {
                context.setStrokeColor(UIColor.white.cgColor)
            } else {
                context.setStrokeColor(strokeColor)
            }
            context.setBlendMode(.normal)
            
            // draw the path
            context.strokePath()
            
            // wrap up the drawing context to render the new line
            mainImage.image = UIGraphicsGetImageFromCurrentImageContext()
            mainImage.alpha = opacity
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
    
    func touchMoved(touch: Set<UITouch>, mainImage: UIImageView, view: UIView, event: UIEvent?) {
        swiped = true
        if let touch = touch.first {
            let currentPoint = touch.location(in: view)
            drawLine(fromPoint: lastPoint, toPoint: currentPoint, mainImage: mainImage, view: view)
            
            // update the lastPoint so the next touch event will continue where you just left off.
            lastPoint = currentPoint
        }
    }
    
    func touchEnded(touch: Set<UITouch>, mainImage: UIImageView, view: UIView, event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLine(fromPoint: lastPoint, toPoint: lastPoint, mainImage: mainImage, view: view)
        }
    }
    
    func resetEraser(view: PaintViewController) {
        eraserSelected = false
        // don't do UI work in your VM
        view.eraserButton.setImage(#imageLiteral(resourceName: "eraserIcon"), for: UIControlState.normal)
    }
    
}
