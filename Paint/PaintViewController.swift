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
    @IBOutlet var changeColorButton: UIButton!
    @IBOutlet weak var changeWidthButton: UIButton!
    
    @IBAction func changeColorButtonClicked(_ sender: AnyObject) {
        self.showColorPicker()
    }

    @IBAction func changeWidthButtonClicked(_ sender: AnyObject) {
        self.showWidthPicker()
    }
    
    @IBAction func clear(_ sender: AnyObject) {
        mainImageView.image = nil
    }
    
    var paintVM = PaintViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       paintVM.touchBegan(touch: touches, paintView: self.view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        paintVM.touchMoved(touch: touches, tempImage: self.tempImageView, view: self.view, event: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        paintVM.touchEnded(touch: touches, tempImage: self.tempImageView, mainImage: self.mainImageView, view: self.view, event: event)
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        paintVM.drawLine(fromPoint: fromPoint, toPoint: toPoint, tempImage: self.tempImageView, view: self.view)
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
    }
    
    // MARK: - Utility functions
    // show color picker from UIButton
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
}
