//
//  UserProfilePersonalDataTableViewCell.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 24/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class UserProfilePersonalDataTableViewCell: UITableViewCell {

    // MARK: Properties
    
    @IBOutlet weak var valueDescription: UILabel!
    @IBOutlet weak var value: UITextField!
    
    // MARK: Cell lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
