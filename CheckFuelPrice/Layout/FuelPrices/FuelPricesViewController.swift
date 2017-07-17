//
//  FuelPricesViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 03/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

// MARK: - Extension: UITableViewDelegate
extension FuelPricesViewController: UITableViewDelegate {
    
}

// MARK: - Extension: UITableViewDataSource
extension FuelPricesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: customTableViewCellName,
                                                                     for: indexPath) as? FuelPricesTableViewCell else {
            
            return UITableViewCell()
        }
        
        let item = self.items[indexPath.row]
        let highestValue = UserConfigurationManager.compute(fromValue: item.currentHighestPrice, fuelType: item.id)
        let lowestValue = UserConfigurationManager.compute(fromValue: item.currentLowestPrice, fuelType: item.id)
        
        cell.highestPriceValue.text = highestValue.strRound(to: 2)
        cell.lowestPricesValue.text = lowestValue.strRound(to: 2)
        cell.fuelName.text = item.name.localized()
        cell.perDateLabel.text = Double(item.timestamp).timestampToString()
        
        let fuelTypeView = cell.fuelUIView.addXib(forType: FuelTypeView.self)
        Utils.setupFuelType(type: item.id.rawValue, inView: fuelTypeView)
        
        return cell
    }


}

class FuelPricesViewController: UIViewController {

    // MARK: - constants
    // Firebase related variables
    var items : [FuelType] = []
    var refFuelTypes : DatabaseReference? = nil
    
    enum LabelDescriptions : String {
        case highestPriceLabel = "highest"
        case lowestPriceLabel = "lowest"
        case appHeading = "AppHeading"
    }
    let customTableViewCellName = "FuelPricesTableViewCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!

    @IBOutlet weak var perDateLabel: UILabel!
    @IBOutlet weak var lowestPriceName: UILabel!
    @IBOutlet weak var highestPriceName: UILabel!
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        log.verbose("Enter: \(self)")
        super.viewDidLoad()

        // Set controller up as a source and delegate for table
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Configure reference to firebase node
        self.refFuelTypes = Database.database().reference(withPath: FirebaseNode.fuelType.rawValue)

        // Set up table header
        highestPriceName.text = LabelDescriptions.highestPriceLabel.rawValue.localized(withDefaultValue: "")
        lowestPriceName.text = LabelDescriptions.lowestPriceLabel.rawValue.localized(withDefaultValue: "")
        perDateLabel.text = ""
        tableView.allowsSelection = false
        
        self.navigationItem.title = "currentFuelPrices".localized().capitalizingFirstLetter()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startObserving()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if refFuelTypes != nil {
            // remove observer
            self.refFuelTypes!.removeAllObservers()
            log.verbose("Observer for node \(FirebaseNode.fuelType.rawValue) removed")
        }
    }
    
    deinit {
        log.verbose("Enter")

    }
    
    // MARK: - Other methods
    
    func getAlertAction(title: String, style : UIAlertActionStyle) -> UIAlertAction {
        
        log.verbose("Creating alert action with title: \(title)")
        let alertAction = UIAlertAction(title: title, style: style) { uiAlertAction in
            
        }
        return alertAction
    }
    

    func startObserving() {
        log.verbose("")
        
        // to avoid retain cycle let's pass weak reference to self
        self.refFuelTypes!.observe(.value, with: { [weak self] snapshot in
            guard let selfweak = self else {
                return
            }
            
            log.verbose("Snapshot: \(snapshot)")
            var newItems: [FuelType] = []
            
            for item in snapshot.children {
                guard let fuelType = FuelType(snapshot: item as! DataSnapshot) else {
                    continue
                }
                // ignore fuel types with zero/uninitialized value
                if fuelType.currentHighestPrice == 0.0 {
                    continue
                }
                newItems.append(fuelType)
            }
            
            selfweak.items = newItems
            selfweak.tableView.reloadData()
            
        })
    }
}
