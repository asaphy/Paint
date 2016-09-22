//
//  WidthViewController.swift
//  Paint
//
//  Created by Asaph Yuan on 9/20/16.
//  Copyright © 2016 Asaph Yuan. All rights reserved.
//

import UIKit

// define delegate protocol function
protocol WidthPickerDelegate: class {
    // return selected width as Int
    func widthSelected(selectedWidth: Int)
}

class WidthViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    @IBOutlet weak var widthCollectionView: UICollectionView!
    var paintVM: PaintViewModel!
    weak var widthPickerDelegate : WidthPickerDelegate?
    var heightOffset = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widthCollectionView.delegate = self
        widthCollectionView.dataSource = self
    }
    
    // return number of section in collection view
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // return number of cell shown within collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paintVM.brushWidths.count
    }
    
    // create collection view cell content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WidthCell", for: indexPath as IndexPath)
        let xValue = Int(view.frame.size.width/2)-paintVM.brushWidths[indexPath.row]
        let widthValue = paintVM.brushWidths[indexPath.row]*2
        let heightValue = paintVM.brushWidths[indexPath.row]*2
        
        cell.frame = CGRect(x: xValue, y: heightOffset, width: widthValue, height: heightValue)
        cell.layer.cornerRadius = CGFloat(paintVM.brushWidths[indexPath.row])
        cell.layer.backgroundColor = paintVM.strokeColor
        heightOffset += paintVM.brushWidths[indexPath.row]*2 + 10
        return cell
    }
    
    // function - called when clicked on a collection view cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        widthPickerDelegate?.widthSelected(selectedWidth: paintVM.brushWidths[indexPath.row])
        closeWidthPicker()
    }
    
    // close color picker view controller
    private func closeWidthPicker(){
        dismiss(animated: false, completion: nil)
    }
}
