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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let settingSection = SettingSection(rawValue: section),
            let config = configuration[settingSection],
            let headerTitle = config[Utils.TableSections.header] else {
                return nil
        }
        
        return headerTitle
    }
}

class SettingsTableViewController: UITableViewController {

    
    // MARK: - Variables/Constants
    enum  SettingSection : Int {
        case theme = 0
        case priceSettings
        case profitMargin
    }
    typealias ConfigType = [SettingSection : [Utils.TableSections : String]]
    
    let configuration : ConfigType = {
        
        return [SettingSection.theme : [Utils.TableSections.header : "theme".localized().capitalizingFirstLetter()],
                SettingSection.priceSettings : [Utils.TableSections.header : "fuelPriceSettings".localized().capitalizingFirstLetter()],
                SettingSection.profitMargin : [Utils.TableSections.header : "profitMarginPerFuelType".localized().capitalizingFirstLetter()]]
    }()
    
    var userConfigRef : DatabaseReference? = nil
    
    
    // MARK: - Outlets/Properties
    
    // MARK: Section: themes
    @IBOutlet weak var theme: UILabel!
    @IBOutlet weak var themeButton: UIButton!
    
    // MARK: Section: fuel price settings
    // producer
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var producerButton: UIButton!
    
    // VAT
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var vatSegment: UISegmentedControl!
    
    // Tax amount
    @IBOutlet weak var taxAmountLabel: UILabel!
    @IBOutlet weak var taxAmountSlider: UISlider!
    @IBOutlet weak var taxAmountValueLabel: UILabel!
    // price unit
    @IBOutlet weak var priceUnitLabel: UILabel!
    @IBOutlet weak var priceUnitSegment: UISegmentedControl!
    
    // MARK: Section: Profit margin per fuel type
    
    @IBOutlet weak var unleaded95Label: UILabel!
    @IBOutlet weak var unleaded95Slider: UISlider!
    @IBOutlet weak var unleaded95ValueLabel: UILabel!
    
    @IBOutlet weak var unleaded98Label: UILabel!
    @IBOutlet weak var unleaded98Slider: UISlider!
    @IBOutlet weak var unleaded98ValueLabel: UILabel!
    
    @IBOutlet weak var dieselLabel: UILabel!
    @IBOutlet weak var dieselSlider: UISlider!
    @IBOutlet weak var dieselValueLabel: UILabel!
    
    @IBOutlet weak var dieselPremiumLabel: UILabel!
    @IBOutlet weak var dieselPremiumSlider: UISlider!
    @IBOutlet weak var dieselPremiumValueLabel: UILabel!
    
    @IBOutlet weak var dieselHeatingLabel: UILabel!
    @IBOutlet weak var dieselHeatingSlider: UISlider!
    @IBOutlet weak var dieselHeatingValueLabel: UILabel!
    

    
    // MARK: - TableViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        log.verbose("")

        initialConfiguration()
        userConfigRef = Database.database().reference(withPath: FirebaseNode.userSettings.rawValue)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self,
                                                                 action: #selector(saveBarButtonTapped))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        log.verbose("")
        startObserving()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        log.verbose("")
        if userConfigRef != nil {
            userConfigRef?.removeAllObservers()
        }
    }
    

    // MARK: - Actions
    
    func saveBarButtonTapped() {
        log.verbose("")
        
        // Firebase uid
        guard let uid = Auth.auth().currentUser?.uid else {
            log.error("This user is not authenticated.")
            return
        }
        
        
        
        let alertController = UIAlertController(title: "doYouWantToSaveData".localized(), message: "",
                                                preferredStyle: UIAlertControllerStyle.alert)
        let actionYes = UIAlertAction(title: "answerYes".localized().capitalizingFirstLetter(),
                                      style: UIAlertActionStyle.default) { (action) in
            
            log.verbose("answered: Yes")
            
            let userConfig = UserConfig(theme: self.themeButton.tag, supplier: self.producerButton.tag,
                                        vatIncluded: self.vatSegment.selectedSegmentIndex,
                                        vatAmount: self.taxAmountSlider.value, capacity: self.priceUnitSegment.selectedSegmentIndex,
                                        unleaded95Margin: self.unleaded95Slider.value, unleaded98Margin: self.unleaded98Slider.value,
                                        dieselMargin: self.dieselSlider.value, dieselPremiumMargin: self.dieselPremiumSlider.value,
                                        dieselHeatingMargin: self.dieselHeatingSlider.value)
            let test = userConfig.toAnyObject()
            self.userConfigRef?.child(uid).setValue(test)
            
            
        }
        let actionNo = UIAlertAction(title: "answerNo".localized().capitalizingFirstLetter(),
                                     style: UIAlertActionStyle.default) { (action) in
            log.verbose("answered: No")
            
        }
        alertController.addAction(actionYes)
        alertController.addAction(actionNo)
        present(alertController, animated: true, completion: nil)
        
    }

    // MARK: - Section: Theme
    
    @IBAction func themeButtonPressed(_ sender: UIButton) {
        log.verbose("")
    }
    
    // MARK: - Section: fuel price settings
    @IBAction func producerButtonPressed(_ sender: UIButton) {
        log.verbose("")
    }
    
    @IBAction func vatOptionSelected(_ sender: UISegmentedControl) {
        log.verbose("")
    }
    
    @IBAction func taxAmountValueChanged(_ sender: UISlider) {
        log.verbose("")
        taxAmountValueLabel.text = getFuelLabelTextFor(sender.value)
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
    
    func startObserving() {
        log.verbose("")
        
        // Firebase uid
        guard let uid = Auth.auth().currentUser?.uid else {
            log.error("This user is not authenticated.")
            return
        }
        userConfigRef?.child(uid).observe(.value, with: { snapshot in
            
            log.verbose("snapshot: \(snapshot)")
            var userConfig = UserConfig()
            if let userConf = UserConfig(snapshot: snapshot) {
                userConfig = userConf
            }
            
            self.setupLayoutWith(userConfig: userConfig)
            
        })
    }
    
    func getFuelLabelTextFor(_ value : Float) -> String {
        return String(format: "%.1f", value) + " %"
    }
    
    func setupLayoutWith(userConfig : UserConfig) {
        log.verbose("")
        
        themeButton.setTitle(String(userConfig.theme), for: UIControlState.normal)
        themeButton.tag = userConfig.theme
        
        producerButton.titleLabel?.text = String(describing: userConfig.supplier)
        producerButton.tag = userConfig.supplier
        
        vatSegment.selectedSegmentIndex = userConfig.vatIncluded
        
        taxAmountSlider.value = userConfig.vatAmount
        taxAmountValueChanged(taxAmountSlider)
        
        priceUnitSegment.selectedSegmentIndex = userConfig.capacity
        
        unleaded95Slider.value = userConfig.unleaded95Margin
        unleaded95ValueChanged(unleaded95Slider)
        unleaded98Slider.value = userConfig.unleaded98Margin
        unleaded98ValueChanged(unleaded98Slider)
        dieselSlider.value = userConfig.dieselMargin
        dieselValueChanged(dieselSlider)
        dieselPremiumSlider.value = userConfig.dieselPremiumMargin
        dieselPremiumValueChanged(dieselPremiumSlider)
        dieselHeatingSlider.value = userConfig.dieselHeatingMargin
        dieselHeatingValueChanged(dieselHeatingSlider)
        
    }
    
    func initialConfiguration() {
        log.verbose("")

        tableView.allowsSelection = false
        theme.text = "theme".localized().capitalizingFirstLetter()
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
