//
//  ColorViewModel.swift
//  Paint
//
//  Created by Asaph Yuan on 9/21/16.
//  Copyright © 2016 Asaph Yuan. All rights reserved.
//

import Foundation
import UIKit

class ColorViewModel{
    // store colors in array (colors will be loaded from Colors.plist)
    // didSet - whenever value set it will refresh collection view.
    var colorList = [String]()

    
    func loadColorList(){
        
        // create path for Colors.plist resource file.
        let colorFilePath = Bundle.main.path(forResource: "Colors", ofType: "plist")
        
        // save piist file array content to NSArray object
        let colorNSArray = NSArray(contentsOfFile: colorFilePath!)
        
        // Cast NSArray to string array.
        if let colors = colorNSArray as? [String] {
            colorList = colors
        }
    }
    
    // convert Hex string '#FF00FF' or 'FF00FF' to UIColor object
    func convertHexToUIColor(hexColor : String) -> UIColor {
        
        //trim unnecessary character set from string
        var colorString : String = hexColor.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // convert to uppercase
        colorString = colorString.uppercased()
        
        //if # found at start then remove it.
        if colorString.hasPrefix("#") {
            //colorString =  colorString.substring(from: colorString.startIndex.advancedBy(1))
            colorString =  colorString.substring(from: colorString.index(colorString.startIndex, offsetBy: 1))
        }
        
        // hex color must 6 chars. if invalid character count then return black color.
        if colorString.characters.count != 6 {
            return UIColor.black
        }
        
        // split R,G,B component
        var rgbValue: UInt32 = 0
        Scanner(string:colorString).scanHexInt32(&rgbValue)
        let valueRed    = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let valueGreen  = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let valueBlue   = CGFloat(rgbValue & 0x0000FF) / 255.0
        let valueAlpha  = CGFloat(1.0)
        
        // return UIColor
        return UIColor(red: valueRed, green: valueGreen, blue: valueBlue, alpha: valueAlpha)
    }

}
