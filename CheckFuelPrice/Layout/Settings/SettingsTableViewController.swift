//
//  SettingsTableViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 01/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import Chameleon

extension SettingsTableViewController {
    
    
    
}

class SettingsTableViewController: UITableViewController {

    
    // MARK: - Property
    
    // MARK: - Section: themes
    @IBOutlet weak var themeColorPrimaryCell: UITableViewCell!
    
    // MARK: - Section: fuel price settings
    @IBOutlet weak var producersCell: UITableViewCell!
    
    @IBOutlet weak var vatCell: UITableViewCell!
    @IBOutlet weak var taxAmountCell: UITableViewCell!
    @IBOutlet weak var priceUnitOfMeasureCell: UITableViewCell!
    
    // MARK: - Section: Profit margin per fuel type
    
    @IBOutlet weak var unleaded95Cell: UITableViewCell!
    @IBOutlet weak var unleaded98Cell: UITableViewCell!
    @IBOutlet weak var dieselCell: UITableViewCell!
    @IBOutlet weak var dieselPremiumCell: UITableViewCell!
    @IBOutlet weak var dieselHeatingCell: UITableViewCell!
    
    // MARK: - TableViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    

}
