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
        let priceValue = self.priceList[indexPath.row]
        fuelPriceCell.price.text = String(format: "%.2f", priceValue)
        
        fuelPriceCell.priceWithVat.text =  String(format: "%.2f", priceValue * (1 + CountryVat.poland.rawValue/100))
        if indexPath.row % 2 == 0 {
            fuelPriceCell.contentView.backgroundColor = .white
        }
        else {
            fuelPriceCell.contentView.backgroundColor = .skyCrayonColor
        }
        
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
            for item in fuelData!.reversed() {
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
        
        // Create table header view using the same tableCellView as for ordinary cell
        let tableHeaderView = self.tableView.dequeueReusableCell(withIdentifier: customTableViewCellName) as? StatisticsTableViewCell
        tableHeaderView?.contentView.backgroundColor = .flatSkyBlue()
        tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        tableHeaderView?.timestamp.text = "timestamp".localized(withDefaultValue: "").capitalizingFirstLetter()
        let priceName = "fuelPrice".localized(withDefaultValue: "").capitalizingFirstLetter()
        tableHeaderView?.price.text = priceName
        tableHeaderView?.priceWithVat.text = priceName + " (" + "withVat".localized(withDefaultValue: "") + ")"

        self.tableView.tableHeaderView = tableHeaderView
        
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
