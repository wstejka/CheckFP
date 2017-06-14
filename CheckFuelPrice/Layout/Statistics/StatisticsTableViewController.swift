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
            self.requestData(for: type!)
        }
    }

    var items : [FuelPriceItem] = []
    var refFuelPriceItems : DatabaseReference? = nil
    var observerHandle : DatabaseHandle = 0
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
        if (self.refFuelPriceItems != nil) && (self.observerHandle > 0) {
            // remove observer
            self.refFuelPriceItems!.removeObserver(withHandle: self.observerHandle)
            log.verbose("Observer for node \(FirebaseNode.fuelType.rawValue) removed")
        }
    }
    
    // MARK: - Methods
    func requestData(for fuel: FuelName) {
        
        // Configure reference to firebase node
        self.refFuelPriceItems = Database.database().reference(withPath: FirebaseNode.fuelPriceItem.rawValue)
        DispatchQueue.global().async {
            // Calculate current epoch timestamp
            let timestamp = Int(Date().timeIntervalSince1970)
            let lastMonthTimestamp = timestamp - (60 * 60 * 24 * 30)

            // to avoid retain cycle let's pass weak reference to self
            let keyPrefix = String(describing: Producer.lotos.hashValue) + "_" + String(describing: fuel.hashValue)
            let startingKey = keyPrefix + "_" + String(describing: lastMonthTimestamp)
            let endingKey = keyPrefix + "_" + String(describing: timestamp)
            
            log.verbose("range keys \(startingKey) - \(endingKey)")
            
            
            self.refFuelPriceItems!.queryOrdered(byChild: "P_FT_T").queryStarting(atValue: startingKey).queryEnding(atValue: endingKey).observeSingleEvent(of: .value, with: { [weak self] snapshot in

                guard let selfweak = self else {
                    return
                }
                log.verbose("Observe: \(selfweak.refFuelPriceItems!.description()) \(snapshot.childrenCount)")
                var newItems: [FuelPriceItem] = []
                for item in snapshot.children {
                    guard let fuelPriceItem = FuelPriceItem(snapshot: item as! DataSnapshot) else {
                        log.verbose("Cannot parse data")
                        continue
                    }
                    newItems.append(fuelPriceItem)
                }
                selfweak.items = newItems
                
            })
        }

    }
}
