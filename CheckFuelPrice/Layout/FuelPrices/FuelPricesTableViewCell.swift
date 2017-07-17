//
//  FuelPricesTableViewCell.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 04/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class FuelPricesTableViewCell: UITableViewCell {

    // REMARK: - Properties
    
    @IBOutlet weak var fuelUIView: UIView!
    @IBOutlet weak var fuelName: UILabel!
    @IBOutlet weak var highestPriceValue: UILabel!
    @IBOutlet weak var lowestPricesValue: UILabel!
    @IBOutlet weak var perDateLabel: UILabel!

}
