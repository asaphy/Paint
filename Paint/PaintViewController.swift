//
//  PaintViewController.swift
//  Paint
//
//  Created by Asaph Yuan on 9/19/16.
//  Copyright © 2016 Asaph Yuan. All rights reserved.
//

import UIKit

final class PaintViewController: UIViewController, UIPopoverPresentationControllerDelegate, ColorPickerDelegate, WidthPickerDelegate {
    
    let paintVM = PaintViewModel()
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet var changeColorButton: UIButton!
    @IBOutlet weak var changeWidthButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    
    @IBAction func changeColorButtonClicked(_ sender: AnyObject) {
        self.showColorPicker()
    }

    @IBAction func changeWidthButtonClicked(_ sender: AnyObject) {
        self.showWidthPicker()
    }

    @IBAction func clear(_ sender: AnyObject) {
        mainImageView.image = nil
    }
    
    @IBAction func eraserButtonSelected(_ sender: AnyObject) {
        paintVM.eraserSelected = !paintVM.eraserSelected
        if paintVM.eraserSelected{
            eraserButton.setImage(#imageLiteral(resourceName: "eraserIconSelected"), for: UIControlState.normal)
        } else {
            eraserButton.setImage(#imageLiteral(resourceName: "eraserIcon"), for: UIControlState.normal)
        }
    }
    
    @IBAction func exportClicked(_ sender: AnyObject) {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0,
                                               width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            present(activity, animated: true, completion: nil)
        }
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let layer = CAShapeLayer()
//        layer.path = UIBezierPath(roundedRect: CGRect(x: 64, y: 64, width: 160, height: 160), cornerRadius: 0).cgPath
//        layer.fillColor = UIColor.red.cgColor
//        view.layer.addSublayer(layer)
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        paintVM.swiped = false
        if let touch = touches.first {
            // update the lastPoint so the next touch event will continue where you just left off.
            paintVM.lastPoint = touch.location(in: view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        paintVM.swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: paintVM.lastPoint, toPoint: currentPoint)
            
            // update the lastPoint so the next touch event will continue where you just left off.
            paintVM.lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !paintVM.swiped {
            // draw a single point
            drawLineFrom(fromPoint: paintVM.lastPoint, toPoint: paintVM.lastPoint)
        }
    }
    
    private func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(view.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            // draws line from last point to current point
            context.move(to: fromPoint)
            context.addLine(to: toPoint)
            // drawing parameters
            context.setLineCap(.round)
            context.setLineWidth(paintVM.brushWidth)
            if paintVM.eraserSelected {
                context.setStrokeColor(UIColor.white.cgColor)
            } else {
                context.setStrokeColor(paintVM.strokeColor)
            }
            context.setBlendMode(.normal)
            
            // draw the path
            context.strokePath()
            
            // wrap up the drawing context to render the new line
            mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
    
    // MARK: Popover delegate functions
    // Override iPhone behavior that presents a popover as fullscreen.
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // MARK: Color picker delegate functions
    // called by color picker after color selected.
    func colorPickerDidColorSelected(selectedUIColor: UIColor, selectedHexColor: String) {
        paintVM.strokeColor = selectedUIColor.cgColor
        resetEraser()
    }
    
    private func showColorPicker(){
        
        if let colorPickerVC = storyboard?.instantiateViewController(withIdentifier: "ColorPicker") as? ColorPickerViewController {
            colorPickerVC.modalPresentationStyle = .popover
            colorPickerVC.preferredContentSize = CGSize(width: 265, height: 400)
            colorPickerVC.colorPickerDelegate = self
            
            if let popoverController = colorPickerVC.popoverPresentationController {
                
                popoverController.sourceView = self.view
                popoverController.sourceRect = self.changeColorButton.frame
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
                popoverController.delegate = self
            }
            
            present(colorPickerVC, animated: true, completion: nil)
        }
    }
    
    // MARK: Width picker delegate functions
    // called by Width picker after Width selected.
    func widthSelected(selectedWidth: Int) {
        paintVM.brushWidth = CGFloat(selectedWidth)
    }

    private func showWidthPicker(){
        
        if let widthPickerVC = storyboard?.instantiateViewController(withIdentifier: "widthPickerVC") as? WidthViewController {
            widthPickerVC.paintVM = paintVM
            widthPickerVC.modalPresentationStyle = .popover
            widthPickerVC.preferredContentSize = CGSize(width: 100, height: 180)
            widthPickerVC.widthPickerDelegate = self
            
            if let popoverController = widthPickerVC.popoverPresentationController {
                
                popoverController.sourceView = self.view
                popoverController.sourceRect = self.changeWidthButton.frame
                popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
                popoverController.delegate = self
            }
            
            present(widthPickerVC, animated: true, completion: nil)
        }
    }
    
    private func resetEraser() {
        paintVM.eraserSelected = false
        eraserButton.setImage(#imageLiteral(resourceName: "eraserIcon"), for: UIControlState.normal)
    }
}
