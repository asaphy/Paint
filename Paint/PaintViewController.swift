//
//  PaintViewController.swift
//  Paint
//
//  Created by Asaph Yuan on 9/19/16.
//  Copyright © 2016 Asaph Yuan. All rights reserved.
//

import UIKit

// mark your classes final unless you plan to subclass them
class PaintViewController: UIViewController, UIPopoverPresentationControllerDelegate, ColorPickerDelegate, WidthPickerDelegate {
    
    // make paintVM a constant unless you need to change its value
    var paintVM = PaintViewModel()
    
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
    
    // remove viewDidLoad unless you need to add to it
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // self is implicit
       paintVM.touchBegan(touch: touches, paintView: self.view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // self
        paintVM.touchMoved(touch: touches, mainImage: self.mainImageView, view: self.view, event: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // self
        paintVM.touchEnded(touch: touches, mainImage: self.mainImageView, view: self.view, event: event)
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        // self
        paintVM.drawLine(fromPoint: fromPoint, toPoint: toPoint, mainImage: self.mainImageView, view: self.view)
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
        paintVM.resetEraser(view: self)
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
}
