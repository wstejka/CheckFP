//
//  FuelInfoTopTableViewCell.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 30/05/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class FuelInfoTopTableViewCell: UITableViewCell {

    
    // MARK: - properties
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImageDescriptionLabel: UILabel!
    @IBOutlet weak var rightImageDescriptionLabel: UILabel!

    override func awakeFromNib() {
        log.verbose("Enter")
    }

}
