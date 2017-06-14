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
    let producer : Producer
    let reference : DatabaseReference?
    
    
    // MARK: - Initializers
    init(timestamp: Int, fuelType: Fuel, price: Double, excise: Double, fee: Double,
        humanReadableDate: String, producer: Producer) {
        
        self.timestamp = timestamp
        self.fuelType = fuelType
        self.price = price
        self.excise = excise
        self.fee = fee
        self.humanReadableDate = humanReadableDate
        self.producer = producer
        self.reference = nil
    }
    
    init(snapshot: DataSnapshot) {
        self.timestamp = Int(snapshot.key)!
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        timestamp = 12345678
        self.fuelType = .dieselHeating
        self.price = 0.0
        self.excise = 0.0
        self.fee = 0.0
        self.humanReadableDate = "2017-05-05"
        self.producer = .lotos
        
        self.reference = snapshot.ref
        print("\(snapshot.key), \(snapshotValue)")
    }

}
