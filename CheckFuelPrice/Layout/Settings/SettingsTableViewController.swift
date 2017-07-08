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
            let config = sectionsConfig[settingSection],
            let headerTitle = config[Utils.TableSections.header] as? String else {
                return nil
        }
        
        return headerTitle
    }
        
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        log.verbose("section: \(indexPath.section), indexPath=\(indexPath.row)")
        let section = indexPath.section
        let row = indexPath.row
        if (section == 0 && row == 0) ||
            (section == 1 && row == 0)
        {
            return true
        }
        return false
        
    }
    
}

class SettingsTableViewController: UITableViewController {

    
    // MARK: - Variables/Constants
    enum  SettingSection : Int {
        case theme = 0
        case priceSettings
        case profitMargin
    }
    
    typealias ConfigType = [SettingSection : [Utils.TableSections : Any]]
    let sectionsConfig : ConfigType = {
        
        return [SettingSection.theme : [Utils.TableSections.header : "theme".localized().capitalizingFirstLetter(),
                                        Utils.TableSections.body : ["theme".localized().capitalizingFirstLetter()]],
                SettingSection.priceSettings : [Utils.TableSections.header : "fuelPriceSettings".localized().capitalizingFirstLetter(),
                                                Utils.TableSections.body : ["fuelSupplier".localized().capitalizingFirstLetter(),
                                                                            "capacity".localized().capitalizingFirstLetter(),
                                                                            "includeVatInFuelPrice".localized().capitalizingFirstLetter(),
                                                                            "vatTaxAmount".localized().capitalizingFirstLetter()]],
                SettingSection.profitMargin : [Utils.TableSections.header : "profitMarginPerFuelType".localized().capitalizingFirstLetter(),
                                               Utils.TableSections.body : ["unleaded95".localized().capitalizingFirstLetter(),
                                                                           "unleaded98".localized().capitalizingFirstLetter(),
                                                                           "diesel".localized().capitalizingFirstLetter(),
                                                                           "dieselIZ40".localized().capitalizingFirstLetter(),
                                                                           "dieselHeating".localized().capitalizingFirstLetter()]]]
    }()
    
    func getRowFor(sectionIndex: Int) -> [String] {
        log.verbose("")
        
        guard let section = SettingSection(rawValue: sectionIndex),
            let sectionData = self.sectionsConfig[section],
        let sectionBody = sectionData[Utils.TableSections.body] as? [String] else {
            log.error("Cannot get data for section: \(sectionIndex)")
                return []
        }
        
        return sectionBody
    }
    
    
    var userConfigRef : DatabaseReference? = nil
    
    var resultSearchController : UISearchController? = nil
    
    // MARK: - Outlets/Properties
    
    // MARK: Section: themes
    @IBOutlet weak var themeTitleLabel: UILabel!
    @IBOutlet weak var themeDetailLabel: UILabel!
    
    // MARK: Section: fuel price settings
    // producer
    @IBOutlet weak var producerTitleLabel: UILabel!
    @IBOutlet weak var producerDetailLabel: UILabel!
    
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
        // Firebase: create reference
        userConfigRef = Database.database().reference(withPath: FirebaseNode.userSettings.rawValue)
        // Create Save button in top navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self,
                                                                 action: #selector(saveBarButtonTapped))
        
        // Instantiate search table view controller
        guard let searchTableView = storyboard!.instantiateViewController(withIdentifier: "SettingsSearchTableViewController") as? SettingsSearchTableViewController else {
            log.error("Cannot instantiate SettingsSearchTableViewController programmatically")
            return
        }
        
        self.resultSearchController = UISearchController(searchResultsController: searchTableView)
        resultSearchController!.searchResultsUpdater = searchTableView
        
        let searchBar = resultSearchController!.searchBar
        tableView.tableHeaderView?.addSubview(searchBar)
        searchBar.sizeToFit()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        log.verbose("")
        startObserving()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        log.verbose("")
        if userConfigRef != nil {
            log.verbose("removeAllObservers")
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
            
            let userConfig = UserConfig(theme: 0, supplier: 1,
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

        self.clearsSelectionOnViewWillAppear = true
                                                                                
        themeTitleLabel.text = "theme".localized().capitalizingFirstLetter()
    
        producerTitleLabel.text = "fuelSupplier".localized().capitalizingFirstLetter()
        
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
