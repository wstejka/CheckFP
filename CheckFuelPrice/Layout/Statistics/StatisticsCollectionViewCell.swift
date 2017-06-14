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
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            
            if isSelected {
                self.imageView.layer.borderColor = UIColor.white.cgColor
                self.imageView.layer.borderWidth = 0.0
            }
            else {
                self.imageView.layer.borderColor = UIColor.white.cgColor
                self.imageView.layer.borderWidth = 5.0
            }
            
        }
    }
    
}
