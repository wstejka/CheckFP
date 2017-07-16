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
    var amount : Float = 0.0
    var capacity : Int = FuelUnit.oneLiter.rawValue
    var fuelType : Int = Fuel.none.rawValue
    var humanReadableDate : String = ""
    var price : Float = 0.0
    var timestamp : Int = Int(Date().timeIntervalSince1970)
    var vatIncluded: Bool = true
    var vatAmount: Float = 23.0
    var position : String = ""
    
    init() {
    }
    
    init(uid : String, amount : Float, capacity: Int, fuelType: Int,
         humanReadableDate: String, price: Float, timestamp: Int,
         vatIncluded: Bool, vatAmount: Float, position: String) {

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
        if let amount = purchaseConfiguration["amount"] as? Float {
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
        if let price = purchaseConfiguration["price"] as? Float {
            self.price = price
        }
        if let timestamp = purchaseConfiguration["timestamp"] as? Int {
            self.timestamp = timestamp
        }
        if let vatIncluded = purchaseConfiguration["vatIncluded"] as? Bool {
            self.vatIncluded = vatIncluded
        }
        if let vatAmount = purchaseConfiguration["vatAmount"] as? Float {
            self.vatAmount = vatAmount
        }
        if let position = purchaseConfiguration["position"] as? String {
            self.position = position
        }
    }
    
    func toAnyObject() -> Any {
        return [
            "amount" : amount.round(to: 2),
            "capacity" : capacity,
            "fuelType" : fuelType,
            "humanReadableDate" : humanReadableDate,
            "price" : price.round(to: 2),
            "timestamp" : timestamp,
            "vatIncluded" : vatIncluded,
            "vatAmount" : vatAmount.round(to: 1),
            "position" : position,
            "uid" : uid
        ]
    }

    
}
