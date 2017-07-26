//
//  PurchasesCollectionViewCell.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class PurchasesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var fuelTypeView: UIView!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountValueLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueValueLabel: UILabel!
    
    // MARK: - Vars/Consts
    var section : Int = 0
    var row : Int = 0
    
}
