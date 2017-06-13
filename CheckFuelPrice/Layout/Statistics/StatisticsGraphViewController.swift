//
//  StatisticsGraphViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class StatisticsGraphViewController: UIViewController, StatisticsGenericProtocol {

    var segment: UISegmentedControl? {
        
        didSet {
            log.verbose("")
        }
    }

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

}
