//
//  SettingsTableViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 01/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import Chameleon
import SwiftyUserDefaults

extension SettingsTableViewController : HandleSettingSearchDelegate {
    
    func selected(search option: SettingsMatchingItem) {
        log.verbose("selected option: \(option)")
        
        let indexPath = IndexPath(row: option.row, section: option.section)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
            DispatchQueue.main.async {
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }        // clear text at searchBar
        self.resultSearchController?.searchBar.text = ""
    }
}

extension SettingsTableViewController : ThemeChangedDelegate {
    
    func selected(theme: ThemesManager.Theme) {
        log.verbose("selected: \(theme)")
        
        Defaults[.currentTheme] = theme.rawValue
        restoreDataFromDefaults()
    }
}

extension SettingsTableViewController : SupplierChangedDelegate {
    
    func selected(supplier: Supplier) {
        log.verbose("selected: \(supplier)")
        
        Defaults[.currentSuplier] = supplier.rawValue
        restoreDataFromDefaults()
    }
}

extension SettingsTableViewController {

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let settingSection = SettingSection(rawValue: section),
            let config = sectionsConfig[settingSection],
            let headerTitle = config[Utils.TableSections.header] as? String else {
                return nil
        }
        
        return headerTitle
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let body = getBodyFor(sectionIndex: indexPath.section)
        let text = body[indexPath.row]
        
        if indexPath.section == SettingSection.theme.rawValue &&
            indexPath.row == FirstSection.theme.rawValue {
            themeTitleLabel.text = text
        }
        else if indexPath.section == SettingSection.priceSettings.rawValue {
            
            if indexPath.row == SecondSection.fuelSupplier.rawValue {
                producerTitleLabel.text = text
            }
            else if indexPath.row == SecondSection.capacity.rawValue {
                priceUnitLabel.text = text
            }
            else if indexPath.row == SecondSection.includeVatInFuelPrice.rawValue {
                vatLabel.text = text
            }
            else if indexPath.row == SecondSection.vatTaxAmount.rawValue {
                taxAmountLabel.text = text
            }
        }
        else if indexPath.section == SettingSection.profitMargin.rawValue {
            
            if indexPath.row == ThirdSection.unleaded95.rawValue {
                unleaded95Label.text = text
            }
            else if indexPath.row == ThirdSection.unleaded98.rawValue {
                unleaded98Label.text = text
            }
            else if indexPath.row == ThirdSection.diesel.rawValue {
                dieselLabel.text = text
            }
            else if indexPath.row == ThirdSection.dieselIZ40.rawValue {
                dieselPremiumLabel.text = text
            }
            else if indexPath.row == ThirdSection.dieselHeating.rawValue {
                dieselHeatingLabel.text = text
            }
        }
    }
        
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        log.verbose("section: \(indexPath.section), indexPath=\(indexPath.row)")
        let section = indexPath.section
        let row = indexPath.row
        if (section == SettingSection.theme.rawValue && row == FirstSection.theme.rawValue) ||
            (section == SettingSection.priceSettings.rawValue && row == SecondSection.fuelSupplier.rawValue)
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
    
    enum FirstSection : Int {
        case theme = 0
    }
    
    enum SecondSection : Int {
        case fuelSupplier
        case capacity
        case includeVatInFuelPrice
        case vatTaxAmount
    }
    
    enum ThirdSection : Int {
        case unleaded95
        case unleaded98
        case diesel
        case dieselIZ40
        case dieselHeating
    }
    
    typealias ConfigType = [SettingSection : [Utils.TableSections : Any]]
    // It should be two-value list. These two represent section and row of selected option
    typealias SelectedRow = [Int]
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
    
    var userConfigRef : DatabaseReference? = nil
    
    var resultSearchController : UISearchController? = nil
    
    var removeFirebaseRef : Bool = true

    // MARK: - Segues
    let settingsSupplierTableViewControllerSegue = "SettingsSupplierTableViewControllerSegue"
    let settingsThemeTableViewControllerSegue = "SettingsThemeTableViewControllerSegue"
    

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
    @IBOutlet weak var vatSwitch: UISwitch!
    
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
        // disable saving data if user is not authenticated
        if Defaults[.isAuthenticated] == false {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        // Instantiate search table view controller
        guard let searchTableViewController = storyboard!.instantiateViewController(withIdentifier: "SettingsSearchTableViewController") as? SettingsSearchTableViewController else {
            log.error("Cannot instantiate SettingsSearchTableViewController programmatically")
            return
        }
        searchTableViewController.sectionsConfig = sectionsConfig
        searchTableViewController.delegate = self
        
        self.resultSearchController = UISearchController(searchResultsController: searchTableViewController)
        resultSearchController?.searchResultsUpdater = searchTableViewController
        
        let searchBar = resultSearchController!.searchBar
        tableView.tableHeaderView?.addSubview(searchBar)
        tableView.tableHeaderView?.sizeToFit()
        
        // hide search bar until table is not scrolled up
        var contentOffset = tableView.contentOffset
        contentOffset.y += searchBar.frame.size.height
        tableView.contentOffset = contentOffset
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        log.verbose("")
        if removeFirebaseRef == true {
            startObserving()
        }
        removeFirebaseRef = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        log.verbose("")
        super.viewDidDisappear(animated)

        // we don't want to remove reference for pushed views created on the top of this one
        if (userConfigRef != nil) &&
            (removeFirebaseRef == true) {
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
            
            let userConfig = UserConfig(theme: Defaults[.currentTheme] ?? ThemesManager.Theme.basic.rawValue,
                                        supplier: Defaults[.currentSuplier] ?? Supplier.none.rawValue,
                                        vatIncluded: self.vatSwitch.isOn,
                                        vatAmount: (self.vatSwitch.isOn ? self.taxAmountSlider.value : 0.0),
                                        capacity: self.priceUnitSegment.selectedSegmentIndex,
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        log.verbose("sender: \(segue.identifier ?? "")")
        
        removeFirebaseRef = false
        if segue.identifier == settingsSupplierTableViewControllerSegue {
            guard let supplierTableVC = segue.destination as? SettingsSupplierTableViewController else {
                return
            }
            
            supplierTableVC.delegate = self
            if let supplier = Defaults[.currentSuplier],
                let supplierObject = Supplier(rawValue: supplier) {
                
                supplierTableVC.currentSupplier = supplierObject
            }
            
        }
        else if segue.identifier == settingsThemeTableViewControllerSegue {
            guard let themeTableVC = segue.destination as? SettingsThemeTableViewController else {
                return
            }
            
            themeTableVC.delegate = self
            if let theme = Defaults[.currentTheme],
                let themeObject = ThemesManager.Theme(rawValue: theme) {
                
                themeTableVC.currentTheme = themeObject
            }
            
        }
    }

    // MARK: - Section: Theme
        
    @IBAction func vatSwitchChanged(_ sender: UISwitch) {
        log.verbose("")
        
        taxAmountValueLabel.isEnabled = sender.isOn
        taxAmountSlider.isEnabled = sender.isOn
        
    }
    
    @IBAction func taxAmountValueChanged(_ sender: UISlider) {
        log.verbose("")
        taxAmountValueLabel.text = sender.value.strRound(to: 0)
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
        return value.strRound(to: 1)
    }
    
    func setupLayoutWith(userConfig : UserConfig) {
        log.verbose("")

        // Provision data
        Defaults[.currentTheme] = userConfig.theme
        Defaults[.currentSuplier] = userConfig.supplier
        Defaults[.currentDefaultCapacity] = userConfig.capacity
        
        Defaults[.currentIncludeVat] = userConfig.vatIncluded
        Defaults[.currentVatTaxAmount] = Double(userConfig.vatAmount)
        Defaults[.currentUnleaded95Margin] = Double(userConfig.unleaded95Margin)
        Defaults[.currentUnleaded98Margin] = Double(userConfig.unleaded98Margin)
        Defaults[.currentDieselMargin] = Double(userConfig.dieselMargin)
        Defaults[.currentDieselSuperMargin] = Double(userConfig.dieselPremiumMargin)
        Defaults[.currentDieselHeatingMargin] = Double(userConfig.dieselHeatingMargin)
        
        restoreDataFromDefaults()        
    }
    
    func initialConfiguration() {
        log.verbose("")

        self.clearsSelectionOnViewWillAppear = true
        self.navigationItem.title = "settings".localized().capitalizingFirstLetter()
        restoreDataFromDefaults()
    }
    
    func restoreDataFromDefaults() {
        // populate fields with previous values
        if let theme = Defaults[.currentTheme],
            let themeObject = ThemesManager.Theme(rawValue: theme){
            
            themeDetailLabel.text = String(describing: themeObject)
        }
        
        if let supplier = Defaults[.currentSuplier],
            let supplierObject = Supplier(rawValue: supplier) {
            
            producerDetailLabel.text = String(describing: supplierObject)
        }
        
        priceUnitSegment.selectedSegmentIndex = Defaults[.currentDefaultCapacity] ?? 0
        vatSwitch.isOn = Defaults[.currentIncludeVat] ?? true
        taxAmountSlider.value = Float(Defaults[.currentVatTaxAmount]?.round(to: 0) ?? 0.0)
        
        unleaded95Slider.value = Float(Defaults[.currentUnleaded95Margin] ?? 0.0)
        unleaded98Slider.value = Float(Defaults[.currentUnleaded98Margin] ?? 0.0)
        dieselSlider.value = Float(Defaults[.currentDieselMargin] ?? 0.0)
        dieselPremiumSlider.value = Float(Defaults[.currentDieselSuperMargin] ?? 0.0)
        dieselHeatingSlider.value = Float(Defaults[.currentDieselHeatingMargin] ?? 0.0)
        
        vatSwitchChanged(vatSwitch)
        taxAmountValueChanged(taxAmountSlider)
        unleaded95ValueChanged(unleaded95Slider)
        unleaded98ValueChanged(unleaded98Slider)
        dieselValueChanged(dieselSlider)
        dieselPremiumValueChanged(dieselPremiumSlider)
        dieselHeatingValueChanged(dieselHeatingSlider)
    }
    
    func getBodyFor(sectionIndex: Int) -> [String] {
        log.verbose("")
        
        guard let section = SettingSection(rawValue: sectionIndex),
            let sectionData = self.sectionsConfig[section],
            let sectionBody = sectionData[Utils.TableSections.body] as? [String] else {
                log.error("Cannot get data for section: \(sectionIndex)")
                return []
        }
        
        return sectionBody
    }
    
}
