//
//  FuelType.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 25/05/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation

enum Fuel : String {
    case none = "none"
    case unleaded95 = "unleaded95"
    case unleaded98 = "unleaded98"
    case diesel = "diesel"
    case dieselIZ40 = "dieselIZ40"
    case dieselHeating = "dieselHeating"
    case lpg = "lpg"
}

enum Producer : String {
    case none = "none"
    case unleaded95 = "unleaded95"
    case unleaded98 = "unleaded98"
}

struct FuelStruct {
    
    // MARK: - Initializers
    let timestamp : Int
    let fuelType : Fuel
    let price : Double
    let excise : Double
    let fee : Double
    let humanReadableDate : String
    let producer : Producer
    
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
    }
    
//    init(snapshot: DataSnapshot) {
//    }

}
