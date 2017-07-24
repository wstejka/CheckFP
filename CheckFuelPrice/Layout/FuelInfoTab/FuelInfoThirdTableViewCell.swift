//
//  FuelInfoThirdTableViewCell.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 24/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class FuelInfoThirdTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var customTitle: UILabel!
    
    
    // MARK: - ViewCell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
