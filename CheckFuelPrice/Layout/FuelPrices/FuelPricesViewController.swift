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
        fuelPriceCell.highestPriceValue.text = String(objectHandler.currentHighestPrice)
        fuelPriceCell.lowestPricesValue.text = String(objectHandler.currentLowestPrice)
        
        if let image = UIImage(named: objectHandler.name) {
            fuelPriceCell.fuelImage.image = image
            //            customViewCell.logoImageView.contentMode = .scaleAspectFit
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
    let customTableViewCellName = "FuelPricesTableViewCell"
    var items : [FuelType] = []
    var refFuelTypes : DatabaseReference? = nil
    var refProducers : DatabaseReference? = nil
    
    enum LabelDescriptions : String {
        case highestPriceLabel = "highestPriceLabel"
        case lowestPriceLabel = "lowestPriceLabel"
        case headingLabel = "AppHeading"
    }
    
    // MARK: - properties
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.refFuelTypes = Database.database().reference(withPath: "fuel_types")

        DispatchQueue.global().async {
            self.refFuelTypes!.observe(.value, with: { snapshot in
                log.verbose("Observe: \(self.refFuelTypes!.description()) \(snapshot.childrenCount)")
                var newItems: [FuelType] = []
                
                for item in snapshot.children {
                    guard let fuelType = FuelType(snapshot: item as! DataSnapshot) else {
                        continue
                    }
                    newItems.append(fuelType)
                }
                
                self.items = newItems
                self.tableView.reloadData()
            })
        }
        
        log.verbose("After")
        
    }


}
