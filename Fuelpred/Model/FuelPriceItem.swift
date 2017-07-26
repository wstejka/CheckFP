//
//  FuelPriceItem.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 25/05/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

struct FuelPriceItem {
    
    // MARK: - Initializers
    var timestamp : Int
    let fuelType : Fuel
    let price : Double
    let excise : Double
    let fee : Double
    let humanReadableDate : String
    let producer : Supplier
    let reference : DatabaseReference?
    
    
    // MARK: - Initializers
    init(timestamp: Int, fuelType: Fuel, price: Double, excise: Double, fee: Double,
        humanReadableDate: String, producer: Supplier) {
        
        self.timestamp = timestamp
        self.fuelType = fuelType
        self.price = price
        self.excise = excise
        self.fee = fee
        self.humanReadableDate = humanReadableDate
        self.producer = producer
        self.reference = nil
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard snapshot.key.length > 0 else {
            return nil
        }
        guard let fuelPriceAttributes = snapshot.value as? [String : AnyObject] else {
            return nil
        }

        self.timestamp = fuelPriceAttributes["timestamp"] as! Int
        guard let fuelId = fuelPriceAttributes["fuelType"] as? Int else {
            return nil
        }
        self.fuelType = Fuel(rawValue: fuelId)!
        self.price = fuelPriceAttributes["price"] as! Double
        self.excise = fuelPriceAttributes["excise"] as! Double
        self.fee = fuelPriceAttributes["fee"] as! Double
        self.humanReadableDate = fuelPriceAttributes["humanReadableDate"] as! String
        guard let producerId = fuelPriceAttributes["producer"] as? Int else {
            return nil
        }
        self.producer = Supplier(rawValue: producerId)! 
        self.reference = snapshot.ref
        
//        log.debug("\(snapshot.key), \(self)")
    }

}
