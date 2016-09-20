//
//  PaintViewController.swift
//  Paint
//
//  Created by Asaph Yuan on 9/19/16.
//  Copyright © 2016 Asaph Yuan. All rights reserved.
//

import UIKit

class PaintViewController: UIViewController, UIPopoverPresentationControllerDelegate, ColorPickerDelegate, WidthPickerDelegate {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    @IBAction func clear(_ sender: AnyObject) {
        mainImageView.image = nil
    }
    // outlet - change color button
    @IBOutlet var changeColorButton: UIButton!
    
    @IBOutlet weak var changeWidthButton: UIButton!
    // action - called when change color button clicked
    @IBAction func changeColorButtonClicked(_ sender: AnyObject) {
        self.showColorPicker()
    }

    @IBAction func changeWidthButtonClicked(_ sender: AnyObject) {
        self.showWidthPicker()
    }
    var paintVM = PaintViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func buttonAction(sender: UIButton!) {
        paintVM.strokeColor = sender.backgroundColor!.cgColor
        print(sender.backgroundColor!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       paintVM.touchBegan(touch: touches, paintView: self.view)
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        paintVM.drawLine(fromPoint: fromPoint, toPoint: toPoint, tempImage: self.tempImageView, view: self.view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        paintVM.touchMoved(touch: touches, tempImage: self.tempImageView, view: self.view, event: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        paintVM.touchEnded(touch: touches, tempImage: self.tempImageView, mainImage: self.mainImageView, view: self.view, event: event)
    }
    
    // MARK: Width picker delegate functions
    // called by Width picker after Width selected.
    func widthSelected(selectedWidth: Int) {
        // update width value within class variable
        print(selectedWidth)
        paintVM.brushWidth = CGFloat(selectedWidth)
    }
    
    // MARK: Popover delegate functions
    // Override iPhone behavior that presents a popover as fullscreen. 
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // MARK: Color picker delegate functions
    // called by color picker after color selected.
    func colorPickerDidColorSelected(selectedUIColor: UIColor, selectedHexColor: String) {
        // update color value within class variable
        paintVM.strokeColor = selectedUIColor.cgColor
    }
    
    // MARK: - Utility functions
    // show color picker from UIButton
    private func showColorPicker(){
        
        // initialise color picker view controller
        let colorPickerVC = storyboard?.instantiateViewController(withIdentifier: "sbColorPicker") as! ColorPickerViewController
        
        // set modal presentation style
        colorPickerVC.modalPresentationStyle = .popover
        
        // set max. size
        colorPickerVC.preferredContentSize = CGSize(width: 265, height: 400)
        
        // set color picker deleagate to current view controller
        // must write delegate method to handle selected color
        colorPickerVC.colorPickerDelegate = self
        
        // show popover
        if let popoverController = colorPickerVC.popoverPresentationController {
            
            // set source view
            popoverController.sourceView = self.view
            
            // show popover from button
            popoverController.sourceRect = self.changeColorButton.frame
            
            // show popover arrow at feasible direction
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            
            // set popover delegate self
            popoverController.delegate = self
        }
        
        //show color popover
        present(colorPickerVC, animated: true, completion: nil)
    }
    
    private func showWidthPicker(){
        
        // initialise color picker view controller
        let widthPickerVC = storyboard?.instantiateViewController(withIdentifier: "widthPickerVC") as! WidthViewController
        widthPickerVC.paintVM = paintVM
        // set modal presentation style
        widthPickerVC.modalPresentationStyle = .popover
        
        // set max. size
        widthPickerVC.preferredContentSize = CGSize(width: 100, height: 180)
        
        // set color picker delegate to current view controller
        // must write delegate method to handle selected color
        widthPickerVC.widthPickerDelegate = self
        
        // show popover
        if let popoverController = widthPickerVC.popoverPresentationController {
            
            // set source view
            popoverController.sourceView = self.view
            // show popover from button
            popoverController.sourceRect = self.changeWidthButton.frame
            
            // show popover arrow at feasible direction
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
            
            // set popover delegate self
            popoverController.delegate = self
        }
        
        //show color popover
        present(widthPickerVC, animated: true, completion: nil)
    }


}
