//
//  StatisticsTableViewCell.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 17/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var priceWithVat: UILabel!
    

    @IBOutlet weak var rightTableCellConstraint: NSLayoutConstraint!
}
