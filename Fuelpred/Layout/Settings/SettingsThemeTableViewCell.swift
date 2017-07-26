//
//  SettingsThemeTableViewCell.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 09/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class SettingsThemeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var color0Label: UILabel!
    @IBOutlet weak var color1Label: UILabel!
    @IBOutlet weak var color2Label: UILabel!
    @IBOutlet weak var color3Label: UILabel!
    
    
    // MARK: - UITableViewCell lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
