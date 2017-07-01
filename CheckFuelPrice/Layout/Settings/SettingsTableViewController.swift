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

    
    // MARK: - Properties/Outlets
    
    // MARK: - Section: themes
    @IBOutlet weak var theme: UILabel!
    
    // MARK: - Section: fuel price settings
    // producer
    @IBOutlet weak var producerLabel: UILabel!
    // VAT
    @IBOutlet weak var vatLabel: UILabel!
    // Tax amount
    @IBOutlet weak var taxAmountLabel: UILabel!
    @IBOutlet weak var taxAmountValueLabel: UILabel!
    // price unit
    @IBOutlet weak var priceUnitLabel: UILabel!
    
    // MARK: - Section: Profit margin per fuel type
    
    @IBOutlet weak var unleaded95Label: UILabel!
    @IBOutlet weak var unleaded95ValueLabel: UILabel!
    
    @IBOutlet weak var unleaded98Label: UILabel!
    @IBOutlet weak var unleaded98ValueLabel: UILabel!
    
    @IBOutlet weak var dieselLabel: UILabel!
    @IBOutlet weak var dieselValueLabel: UILabel!
    
    @IBOutlet weak var dieselPremiumLabel: UILabel!
    @IBOutlet weak var dieselPremiumValueLabel: UILabel!
    
    @IBOutlet weak var dieselHeatingLabel: UILabel!
    @IBOutlet weak var dieselHeatingValueLabel: UILabel!
    
    // MARK: - TableViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initialConfiguration()
    }
    
    
    // MARK: - Actions
    // MARK: - Section: fuel price settings
    @IBAction func producerButtonPressed(_ sender: UIButton) {
        log.verbose("")
    }
    
    @IBAction func vatOptionSelected(_ sender: UISegmentedControl) {
        log.verbose("")
    }
    
    @IBAction func taxAmountValueChanged(_ sender: UISlider) {
        log.verbose("")
    }

    @IBAction func priceUnitValueChanged(_ sender: UISegmentedControl) {
        log.verbose("")
    }

    // MARK: - Section: Profit margin per fuel type
    
    @IBAction func unleaded95ValueChanged(_ sender: UISlider) {
        log.verbose("")
        unleaded95ValueLabel.text = getFuelLabelTextFor(sender.value)
    }
    
    @IBAction func unleaded98ValueChanged(_ sender: UISlider) {
        log.verbose("")
        unleaded98ValueLabel.text = getFuelLabelTextFor(sender.value)
    }

    @IBAction func dieselValueChanged(_ sender: UISlider) {
        log.verbose("")
        dieselValueLabel.text = getFuelLabelTextFor(sender.value)
    }

    @IBAction func dieselPremiumValueChanged(_ sender: UISlider) {
        log.verbose("")
        dieselPremiumValueLabel.text = getFuelLabelTextFor(sender.value)
    }

    @IBAction func dieselHeatingValueChanged(_ sender: UISlider) {
        log.verbose("")
        dieselHeatingValueLabel.text = getFuelLabelTextFor(sender.value)
    }

    
    
    // MARK: - Methods
    
    func getFuelLabelTextFor(_ value : Float) -> String {
        return String(format: "%.1f", value) + " %"
    }
    
    func initialConfiguration() {
        log.verbose("")

        producerLabel.text = "fuelSupplier".localized().capitalizingFirstLetter()
        vatLabel.text = "includeVatInFuelPrice".localized().capitalizingFirstLetter()
        taxAmountLabel.text = "vatTaxAmount".localized().capitalizingFirstLetter()
        priceUnitLabel.text = "capacity".localized().capitalizingFirstLetter()

        unleaded95Label.text = "unleaded95".localized().capitalizingFirstLetter()
        unleaded98Label.text = "unleaded98".localized().capitalizingFirstLetter()
        dieselLabel.text = "diesel".localized().capitalizingFirstLetter()
        dieselPremiumLabel.text = "dieselIZ40".localized().capitalizingFirstLetter()
        dieselHeatingLabel.text = "dieselHeating".localized().capitalizingFirstLetter()
                
        
    }
    
}
