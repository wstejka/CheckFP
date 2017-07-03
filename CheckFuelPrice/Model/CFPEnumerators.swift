//
//  CFPEnumerators.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 27/05/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

enum Fuel : Int {
    case none = 0
    case unleaded95
    case unleaded98
    case diesel
    case dieselIZ40
    case dieselHeating
    case lpg
}

enum Producer : Int {
    case none = 0
    case lotos
    case orlen
    
    
    init?(withName: String?) {
        
        guard let name = withName else { return nil }
        switch name.lowercased() {
        case "none":
            self = .none
        case "lotos":
            self = .lotos
        case "orlen":
            self = .orlen
        default:
            log.error("option \(name) not defined")
            return nil
        }
    }
}

enum FuelUnit : Int {
    case oneLiter
    case thousandLiters
}


