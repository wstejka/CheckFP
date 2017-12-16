//
// Created by Wojciech Stejka
// Copyright (c) 2017 Wojciech Stejka. All rights reserved.
//

import Foundation

class FuelPricesRemoteDataManager: FuelPricesRemoteDataManagerInputProtocol
{
    var refFuelTypes : DatabaseReference?
    func initiate() {
        // Configure reference to firebase node
        refFuelTypes = Database.database().reference(withPath: FirebaseNode.fuelType.rawValue)
    }
    
    func startObserving(_ completion: @escaping FuelPricesCompletionHandler) {
        log.verbose("")
        
        guard let reference = refFuelTypes else {
            log.error("Un-initialized firebase reference")
            fatalError()
        }

        reference.observe(.value, with: { snapshot in
            
            log.verbose("Snapshot: \(snapshot)")
            var items : [FuelType] = []
            
            for item in snapshot.children {
                guard let fuelType = FuelType(snapshot: item as! DataSnapshot) else {
                    continue
                }
                // ignore fuel types with zero/uninitialized value
                if fuelType.currentHighestPrice == 0.0 {
                    continue
                }
                items.append(fuelType)
            }
            
            completion(items)
        })
    }
    
    func stopObserving() {
        // remove observer
        self.refFuelTypes?.removeAllObservers()
        log.verbose("Observer removed")
    }
}
