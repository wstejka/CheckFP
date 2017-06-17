//
//  StatisticsTableViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

extension StatisticsTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        log.verbose("entered")
        return dateList.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        log.verbose("entered")
        guard let fuelPriceCell = self.tableView.dequeueReusableCell(withIdentifier: customTableViewCellName,
                                                                     for: indexPath) as? StatisticsTableViewCell else {
                                                                        
            return UITableViewCell()
        }
        fuelPriceCell.timestamp.text = self.dateList[indexPath.row]
        fuelPriceCell.priceDescription.text = "price".localized(withDefaultValue: "")
        fuelPriceCell.price.text = String(self.priceList[indexPath.row])
        
        return fuelPriceCell
    }
    
}

class StatisticsTableViewController: UIViewController, StatisticsGenericProtocol {
    
    // MARK: - constants
    
    
    var type: FuelName? {
        
        didSet {
            log.verbose("\(type?.rawValue ?? "")")
        }
    }
    let customTableViewCellName = "Cell"
    
    var dateList : [String] = []
    var priceList : [Double] = []
    
    var fuelData: [FuelPriceItem]?  {
        
        didSet {
            log.verbose("# of data \(fuelData?.count ?? 0)")
            dateList = []
            priceList = []
            for item in fuelData! {
                self.dateList.append(item.humanReadableDate)
                self.priceList.append(item.price)
            }
            
            if self.tableView != nil {
                self.tableView.reloadData()
            }
            
        }
    }

    let defaultSection = 0
    
    // MARK: - properties
    
    @IBOutlet weak var tableView: UITableView!
    

    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        log.verbose("entered")
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Added for debugging purpose
    deinit {
        log.verbose("")

    }
    
    // MARK: - Methods
}
