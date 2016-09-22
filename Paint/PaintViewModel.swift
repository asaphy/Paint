//
//  PaintViewModel.swift
//  Paint
//
//  Created by Asaph Yuan on 9/19/16.
//  Copyright © 2016 Asaph Yuan. All rights reserved.
//

import Foundation
import UIKit

struct PaintViewModel{
    var lastPoint = CGPoint.zero
    var strokeColor = UIColor.black.cgColor
    var brushWidth: CGFloat = 10.0
    var swiped = false
    let brushWidths = [4, 8, 16, 32]
    var eraserSelected = false
}
