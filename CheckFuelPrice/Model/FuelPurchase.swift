//
//  Purchase.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//


//! This struct represents user's purchase
struct FuelPurchase {

    var uid : String = ""
    var amount : Double = 0.0
    var capacity : Int = FuelUnit.oneLiter.rawValue
    var fuelType : Int = Fuel.none.rawValue
    var humanReadableDate : String = ""
    var price : Double = 0.0
    var timestamp : Int = Int(Date().timeIntervalSince1970)
    var vatIncluded: Bool = true
    var vatAmount: Double = 23.0
    var position : String = ""
    
    init() {
    }
    
    init(uid : String, amount : Double, capacity: Int, fuelType: Int,
         humanReadableDate: String, price: Double, timestamp: Int,
         vatIncluded: Bool, vatAmount: Double, position: String) {

        self.uid = uid
        self.amount = amount
        self.capacity = capacity
        self.fuelType = fuelType
        self.humanReadableDate = humanReadableDate
        self.price = price
        self.timestamp = timestamp
        self.vatIncluded = vatIncluded
        self.vatAmount = vatAmount
        self.position = position
        
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let purchaseConfiguration = snapshot.value as? [String : AnyObject] else {
            return nil
        }
        
        self.position = snapshot.key
        if let uid = purchaseConfiguration["uid"] as? String {
            self.uid = uid
        }
        if let amount = purchaseConfiguration["amount"] as? Double {
            self.amount = amount
        }
        if let capacity = purchaseConfiguration["capacity"] as? Int {
            self.capacity = capacity
        }
        if let fuelType = purchaseConfiguration["fuelType"] as? Int {
            self.fuelType = fuelType
        }
        if let humanReadableDate = purchaseConfiguration["humanReadableDate"] as? String {
            self.humanReadableDate = humanReadableDate
        }
        if let price = purchaseConfiguration["price"] as? Double {
            self.price = price
        }
        if let timestamp = purchaseConfiguration["timestamp"] as? Int {
            self.timestamp = timestamp
        }
        if let vatIncluded = purchaseConfiguration["vatIncluded"] as? Bool {
            self.vatIncluded = vatIncluded
        }
        if let vatAmount = purchaseConfiguration["vatAmount"] as? Double {
            self.vatAmount = vatAmount
        }
        if let position = purchaseConfiguration["position"] as? String {
            self.position = position
        }
    }
    
    func toAnyObject() -> Any {
        return [
            "amount" : amount,
            "capacity" : capacity,
            "fuelType" : fuelType,
            "humanReadableDate" : humanReadableDate,
            "price" : price,
            "timestamp" : timestamp,
            "vatIncluded" : vatIncluded,
            "vatAmount" : vatAmount,
            "position" : position,
            "uid" : uid
        ]
    }

    
}
