//
//  FuelType.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 27/05/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

struct FuelType {
    
    let currentHighestPrice : Double
    let currentHighestPriceReference : String
    let currentLowestPrice : Double
    let currentLowestPriceReference : String
    let id : Fuel
    let name : String
    let timestamp : Int
    
    init(id : Fuel, name : String, timestamp: Int,
         currentHighestPrice : Double, currentHighestPriceReference : String,
         currentLowestPrice : Double, currentLowestPriceReference : String) {
        
        self.currentHighestPrice = currentHighestPrice
        self.currentHighestPriceReference = currentHighestPriceReference
        self.currentLowestPrice = currentLowestPrice
        self.currentLowestPriceReference = currentLowestPriceReference
        self.id = id
        self.name = name
        self.timestamp = timestamp
    }
    
    init?(snapshot: DataSnapshot) {

        guard let key = Int(snapshot.key) else {
            return nil
        }
        guard let id = Fuel(rawValue: key) else {
            return nil
        }
        self.id = id
        guard let fuelTypeAttributes = snapshot.value as? [String : AnyObject] else {
            return nil
        }
        
        self.currentHighestPrice = fuelTypeAttributes["currentHighestPrice"] as! Double
        self.currentLowestPrice = fuelTypeAttributes["currentLowestPrice"] as! Double
        self.name = fuelTypeAttributes["name"] as! String
        self.timestamp = fuelTypeAttributes["timestamp"] as! Int
        
        if fuelTypeAttributes.index(forKey: "currentHighestPriceReference") != nil {
            self.currentHighestPriceReference = fuelTypeAttributes["currentHighestPriceReference"] as! String
        }
        else {self.currentHighestPriceReference = ""}
        
        if fuelTypeAttributes.index(forKey: "currentLowestPriceReference") != nil {
            self.currentLowestPriceReference = fuelTypeAttributes["currentLowestPriceReference"] as! String
        }
        else {self.currentLowestPriceReference = ""}

    }

}
