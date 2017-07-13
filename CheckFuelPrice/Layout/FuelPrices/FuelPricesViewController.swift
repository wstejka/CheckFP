//
//  FuelPricesViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 03/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

extension FuelPricesViewController: UITableViewDelegate {
    
}

extension FuelPricesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let fuelPriceCell = self.tableView.dequeueReusableCell(withIdentifier: customTableViewCellName,
                                                                     for: indexPath) as? FuelPricesTableViewCell else {
            
            return UITableViewCell()
        }
        
        let objectHandler = self.items[indexPath.row]
        fuelPriceCell.highestPriceName.text = LabelDescriptions.highestPriceLabel.rawValue.localized(withDefaultValue: "")
        fuelPriceCell.lowestPriceName.text = LabelDescriptions.lowestPriceLabel.rawValue.localized(withDefaultValue: "")
        fuelPriceCell.highestPriceValue.text = String(format: "%.1f", objectHandler.currentHighestPrice)
        fuelPriceCell.lowestPricesValue.text = String(format: "%.1f", objectHandler.currentLowestPrice)
        fuelPriceCell.perDateLabel.text = Double(objectHandler.timestamp).timestampToString()
        fuelPriceCell.fuelName.text = objectHandler.name.localized()
        
        if let image = UIImage(named: objectHandler.name) {
            fuelPriceCell.fuelImage.image = image
            fuelPriceCell.fuelImage.layer.cornerRadius = 10
            fuelPriceCell.fuelImage.clipsToBounds = true
        }
        else
        {
            fuelPriceCell.fuelImage.image = nil
        }
          
        return fuelPriceCell
    }
}

class FuelPricesViewController: UIViewController {

    // MARK: - constants
    // Firebase related variables
    var items : [FuelType] = []
    var refFuelTypes : DatabaseReference? = nil
    var observerHandle : DatabaseHandle = 0
    
    enum LabelDescriptions : String {
        case highestPriceLabel = "highest"
        case lowestPriceLabel = "lowest"
        case pricePerDay = "pricePerDay"
    }
    let customTableViewCellName = "FuelPricesTableViewCell"
    
    // MARK: - properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var pricePerDayLabel: UILabel!
    
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        log.verbose("Enter: \(self)")
        super.viewDidLoad()

        // Set controller up as a source and delegate for table
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.pricePerDayLabel.text = "AppHeading".localized().capitalizingFirstLetter() + ":"

        // Configure reference to firebase node
        self.refFuelTypes = Database.database().reference(withPath: FirebaseNode.fuelType.rawValue)
        DispatchQueue.global().async {
            // to avoid retain cycle let's pass weak reference to self
            self.observerHandle = self.refFuelTypes!.observe(.value, with: { [weak self] snapshot in
                guard let selfweak = self else {
                    return
                }
                
                log.verbose("Updated: \(snapshot)")
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
    
    deinit {
        log.verbose("Enter")
        if (self.refFuelTypes != nil) && (self.observerHandle > 0) {
            // remove observer
            self.refFuelTypes!.removeObserver(withHandle: self.observerHandle)
            log.verbose("Observer for node \(FirebaseNode.fuelType.rawValue) removed")
        }
    }
    
    // MARK: - Other methods
    
    func getAlertAction(title: String, style : UIAlertActionStyle) -> UIAlertAction {
        
        log.verbose("Creating alert action with title: \(title)")
        let alertAction = UIAlertAction(title: title, style: style) { uiAlertAction in
            
        }
        return alertAction
    }
    

}
