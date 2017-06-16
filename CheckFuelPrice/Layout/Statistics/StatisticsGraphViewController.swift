//
//  StatisticsGraphViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import Charts

class StatisticsGraphViewController: UIViewController, StatisticsGenericProtocol {

    
    @IBOutlet var testView: LineChartView!
    
    var type: FuelName? {
        
        didSet {
            log.verbose("\(type?.rawValue ?? "")")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        log.verbose("entered")
        testView.noDataText = "no data test message "
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Added for debugging purpose
    deinit {
        log.verbose("")
    }

}
