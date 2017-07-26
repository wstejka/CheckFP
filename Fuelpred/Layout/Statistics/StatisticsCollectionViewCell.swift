//
//  StatisticsCollectionViewCell.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 13/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class StatisticsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - properties
    @IBOutlet weak var view: UIView!
    
    override var isSelected: Bool {
        didSet {

//            view.shake(direction: ShakeDirection.Horizontal)
//            if isSelected {
//                self.view.layer.borderWidth = 0.0
//            }
//            else {
//                self.view.layer.borderWidth = 5.0
//            }
//            self.view.layer.borderColor = UIColor.white.cgColor
        }
    }
    
}
