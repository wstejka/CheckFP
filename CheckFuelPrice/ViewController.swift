//
//  ViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 14/04/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    // MARK: - constants
    let customTableViewCellName = "FuelTableViewCellId"
    var items : [FuelType] = []
    var ref : DatabaseReference? = nil
    enum LabelDescription : String {
        case highestPriceLabel = "highestPriceLabel"
        case lowestPriceLabel = "lowestPriceLabel"
    }
    
    
    // MARK: - properties
    
    @IBOutlet weak var fuelTableView: UITableView!
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fuelTableView.dataSource = self
        self.ref = Database.database().reference(withPath: "fuel_types")
        
        ref!.observe(.value, with: { snapshot in
            log.verbose("observe \(snapshot.childrenCount)")
            var newItems: [FuelType] = []
            
            for item in snapshot.children {
                guard let fuelType = FuelType(snapshot: item as! DataSnapshot) else {
                    continue
                }
                newItems.append(fuelType)
            }
            
            self.items = newItems
            self.fuelTableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let customViewCell = self.fuelTableView.dequeueReusableCell(withIdentifier: self.customTableViewCellName) as? FuelTableViewCell else {
            return UITableViewCell()
        }
        // Headings
        customViewCell.highestPriceDescription.text = LabelDescription.highestPriceLabel.rawValue.localized(withDefaultValue: "")
        customViewCell.lowestPriceDescription.text = LabelDescription.lowestPriceLabel.rawValue.localized(withDefaultValue: "")
        
        
        let objectHandler = self.items[indexPath.row]
        customViewCell.highestPriceValue.text = String(objectHandler.currentHighestPrice)
        customViewCell.lowestPriceValue.text = String(objectHandler.currentLowestPrice)
        customViewCell.fuelName.text = objectHandler.name.localized(withDefaultValue: "")
        customViewCell.date.text = Double(objectHandler.timestamp).timestampToString()
        customViewCell.accessoryType = .detailButton
        
        return customViewCell
    }


    // MARK: - Actions
}

