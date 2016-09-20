//
//  WidthViewController.swift
//  Paint
//
//  Created by Asaph Yuan on 9/20/16.
//  Copyright © 2016 Asaph Yuan. All rights reserved.
//

import UIKit

// define delegate protocol function
protocol WidthPickerDelegate {
    // return selected width as Int
    func widthSelected(selectedWidth: Int)
}

class WidthViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    @IBOutlet weak var widthCollectionView: UICollectionView!
    var paintVM: PaintViewModel!
    var widthPickerDelegate : WidthPickerDelegate?
    var heightOffset = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.widthCollectionView.delegate = self
        self.widthCollectionView.dataSource = self
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
        cell.frame = CGRect(x: Int(view.frame.size.width/2)-paintVM.brushWidths[indexPath.row], y: heightOffset, width: paintVM.brushWidths[indexPath.row]*2, height: paintVM.brushWidths[indexPath.row]*2)
        cell.layer.cornerRadius = CGFloat(paintVM.brushWidths[indexPath.row])
        cell.layer.backgroundColor = paintVM.strokeColor
        heightOffset += paintVM.brushWidths[indexPath.row]*2 + 10
        return cell
    }
    
    // function - called when clicked on a collection view cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.widthPickerDelegate?.widthSelected(selectedWidth: paintVM.brushWidths[indexPath.row])
        self.closeWidthPicker()
    }
    
    // close color picker view controller
    private func closeWidthPicker(){
        self.dismiss(animated: false, completion: nil)
    }
}
