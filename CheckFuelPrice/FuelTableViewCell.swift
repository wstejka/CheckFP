//
//  FuelTableViewCell.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 25/05/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class FuelTableViewCell: UITableViewCell {

    // MARK: - properties
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var highestPriceDescription: UILabel!
    @IBOutlet weak var highestPriceValue: UILabel!
    @IBOutlet weak var lowestPriceDescription: UILabel!
    @IBOutlet weak var lowestPriceValue: UILabel!
    
    // MARK: - UITableViewCell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
