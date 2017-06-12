//
//  StatisticsViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

protocol StatisticsViewControllerDelegate {
    
    func selected(segment : UISegmentedControl)
}

class StatisticsViewController: UIViewController {
    
    
    // MARK: - constants
    enum TimeRanges : String {
        case weekly = "weekly"
        case monthly = "monthly"
        case annually = "annually"
        
    }
    
    
    
    // MARK: - properties
    @IBOutlet weak var timeRangesSegments: UISegmentedControl!
    
    // delegate
    var delegate : StatisticsViewControllerDelegate?
    
    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        log.verbose("entered")


        // initiate segments with localized names
        for range in iterateEnum(StatisticsViewController.TimeRanges.self) {
            
            self.timeRangesSegments.setTitle(range.rawValue.localized(withDefaultValue: ""),
                                             forSegmentAt: range.hashValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Actions
    @IBAction func timeRangesSegmentsChanged(_ sender: UISegmentedControl) {
        
        log.verbose("selected index: \(sender.selectedSegmentIndex)")
        delegate?.selected(segment: sender)
    }
}
