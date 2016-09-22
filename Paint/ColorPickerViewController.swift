//
//  ColorPickerViewController.swift
//  SwiftColorPicker
//
//  Created by Prashant on 02/09/15.
//  Copyright (c) 2015 PrashantKumar Mangukiya. All rights reserved.
//

import UIKit


// define delegate protocol function
protocol ColorPickerDelegate {
    
    // return selected color as UIColor and Hex string
    func colorPickerDidColorSelected(selectedUIColor: UIColor, selectedHexColor: String)
}

class ColorPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // create color picker delegate
    var colorPickerDelegate : ColorPickerDelegate?
    
    let colorVM = ColorViewModel()
    
    // outlet - colors collection view
    @IBOutlet var colorCollectionView : UICollectionView!
    
    
    // MARK: - View functions
    
    // called after view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set collection view delegate and datasource
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        // load colors from plist file
        colorVM.loadColorList()
        colorCollectionView.reloadData()
    }
    
    // MARK: - Collection view Datasource & Delegate functions
    
    // return number of section in collection view
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // return number of cell shown within collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorVM.colorList.count
    }
    
    // create collection view cell content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // deque reusable cell from collection view.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath as IndexPath) 
        
        // set cell background color from given color list
        cell.backgroundColor = colorVM.convertHexToUIColor(hexColor: colorVM.colorList[indexPath.row])
        
        // return cell
        return cell
    }
    
    // function - called when clicked on a collection view cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // find clicked color value from colorList (it wil be in hex)
        let clickedHexColor = colorVM.colorList[indexPath.row]
        
        // convert hex color to UI Color
        let clickedUIColor = colorVM.convertHexToUIColor(hexColor: clickedHexColor)

        // call delegate function i.e. return selected color
        colorPickerDelegate?.colorPickerDidColorSelected(selectedUIColor: clickedUIColor, selectedHexColor: clickedHexColor)
        
        // close color picker view
        closeColorPicker()
    }
    
    // close color picker view controller
    private func closeColorPicker(){
        dismiss(animated: false, completion: nil)
    }

}

