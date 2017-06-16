//
//  StatisticsTableViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class StatisticsTableViewController: UIViewController, StatisticsGenericProtocol {
    
    // MARK: - constants
    
    
    var type: FuelName? {
        
        didSet {
            log.verbose("\(type?.rawValue ?? "")")
        }
    }

    var fuelData: [FuelPriceItem]?  {
        
        didSet {
            log.verbose("# of data \(fuelData?.count ?? 0)")
        }
    }
    

    let defaultSection = 0
    
    // MARK: - properties

    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        log.verbose("entered")
        
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
