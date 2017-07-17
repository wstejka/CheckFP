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
        
        guard let fuelPriceCell = self.tableView.dequeueReusableCell(withIdentifier: customTableViewCellName,
                                                                     for: indexPath) as? StatisticsTableViewCell else {
                                                                        
            return UITableViewCell()
        }
        fuelPriceCell.timestamp.text = self.dateList[indexPath.row]
        let priceValue = self.priceList[indexPath.row]
        
        if UserConfigurationManager.getUserConfig().vatIncluded == false {
            fuelPriceCell.price.text = ""
            fuelPriceCell.priceWithVat.text = UserConfigurationManager.compute(fromValue: priceValue, includeVat: false).strRound(to: 2)
        }
        else {
            fuelPriceCell.price.text = UserConfigurationManager.compute(fromValue: priceValue, includeVat: false).strRound(to: 2)
            fuelPriceCell.priceWithVat.text = UserConfigurationManager.compute(fromValue: priceValue).strRound(to: 2)
        }
        fuelPriceCell.contentView.backgroundColor = .white
        
        return fuelPriceCell
    }
    
}

class StatisticsTableViewController: UIViewController, StatisticsGenericProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var wholesaleLabel: UILabel!
    @IBOutlet weak var retailLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var rightLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelConstraint: NSLayoutConstraint!
    
    
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
        
        initializeTableHeader()
    }

    
    // Added for debugging purpose
    deinit {
        log.verbose("")
    }
    
    // MARK: - Methods
    
    func initializeTableHeader() {
        log.verbose("")
        
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableHeaderView.backgroundColor = ThemesManager.get(color: .primary)
        self.dateLabel.text = "timestamp".localized(withDefaultValue: "").capitalizingFirstLetter()

        let priceName = "price".localized(withDefaultValue: "").capitalizingFirstLetter()
        self.descriptionLabel.text = priceName
        
        if UserConfigurationManager.getUserConfig().vatIncluded == true {
            self.wholesaleLabel.text = "wholesale".localized()
            self.retailLabel.text = "retail".localized()
            rightLabelConstraint.constant += 10
            descriptionLabelConstraint.constant += 10
        }
        else {
            self.wholesaleLabel.text = ""
            self.retailLabel.text = "wholesale".localized()
            if UserConfigurationManager.getUserConfig().capacity == FuelUnit.thousandLiters.rawValue {
                rightLabelConstraint.constant += 10
            }
            descriptionLabelConstraint.constant = rightLabelConstraint.constant
        }
    }
}
