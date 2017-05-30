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
    var refFuelTypes : DatabaseReference? = nil
    var refProducers : DatabaseReference? = nil
    enum LabelDescriptions : String {
        case highestPriceLabel = "highestPriceLabel"
        case lowestPriceLabel = "lowestPriceLabel"
        case headingLabel = "AppHeading"
    }
    
    
    // MARK: - properties
    
    @IBOutlet weak var fuelTableView: UITableView!
    @IBOutlet weak var tableHeading: UILabel!
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.fuelTableView.dataSource = self
        self.fuelTableView.delegate = self
        
        self.refFuelTypes = Database.database().reference(withPath: "fuel_types")
        self.tableHeading.text = LabelDescriptions.headingLabel.rawValue.localized(withDefaultValue: "")
        
        DispatchQueue.global().async {
//            self.refFuelTypes!.queryOrdered(byChild: "currentHighestPrice").observe(.value, with: { snapshot in
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
                self.fuelTableView.reloadData()
            })
        }
        
        log.verbose("After")
        
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
        customViewCell.highestPriceDescription.text = LabelDescriptions.highestPriceLabel.rawValue.localized(withDefaultValue: "")
        customViewCell.lowestPriceDescription.text = LabelDescriptions.lowestPriceLabel.rawValue.localized(withDefaultValue: "")
        
        // Values
        let objectHandler = self.items[indexPath.row]
        customViewCell.highestPriceValue.text = String(objectHandler.currentHighestPrice)
        customViewCell.lowestPriceValue.text = String(objectHandler.currentLowestPrice)
        customViewCell.fuelName.text = objectHandler.name.localized(withDefaultValue: "")
        customViewCell.date.text = Double(objectHandler.timestamp).timestampToString()
        customViewCell.accessoryType = .disclosureIndicator
        // Image logo
        let imageName = "logo_" + objectHandler.name;
        
        if let image = UIImage(named: imageName) {
            customViewCell.logoImageView.image = image
//            customViewCell.logoImageView.contentMode = .scaleAspectFit
            customViewCell.logoImageView.layer.cornerRadius = 10
            customViewCell.logoImageView.clipsToBounds = true
        }
        else
        {
            customViewCell.logoImageView.image = nil
        }
        
        return customViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        log.verbose("Cell tapped at index: \(indexPath.row)")
        
        
        
    }


    // MARK: - Actions
}

