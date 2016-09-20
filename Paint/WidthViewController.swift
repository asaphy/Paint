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
    var heightOffset = 10
    let brushWidths = [4, 8, 16, 32]
    var counter = 0
    @IBOutlet weak var widthCollectionView: UICollectionView!
    var paintVM: PaintViewModel!

    // create width picker delegate
    var widthPickerDelegate : WidthPickerDelegate?
    
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
        return brushWidths.count
    }
    
    
    // create collection view cell content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // deque reusable cell from collection view.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WidthCell", for: indexPath as IndexPath)
        cell.backgroundColor = UIColor.clear
        cell.frame = CGRect(x: Int(view.frame.size.width/2)-brushWidths[counter], y: heightOffset, width: brushWidths[counter]*2, height: brushWidths[counter]*2)
        cell.layer.cornerRadius = CGFloat(brushWidths[counter])
        cell.layer.backgroundColor = paintVM.strokeColor
        heightOffset += brushWidths[counter]*2 + 10
        counter += 1
        return cell
    }
    
    // function - called when clicked on a collection view cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(brushWidths[indexPath.row])
        self.widthPickerDelegate?.widthSelected(selectedWidth: brushWidths[indexPath.row])
        self.closeWidthPicker()
    }
    
    // close color picker view controller
    private func closeWidthPicker(){
        self.dismiss(animated: false, completion: nil)
    }
}
