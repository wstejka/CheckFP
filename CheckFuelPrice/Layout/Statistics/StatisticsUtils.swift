//
//  StatisticsUtils.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 13/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation


enum TimeRanges : String {
    case weekly     = "weekly"
    case monthly    = "monthly"
    case annually   = "annually"
}


enum FuelName : String {
    case unleaded95     = "unleaded95"
    case unleaded98     = "unleaded98"
    case diesel         = "diesel"
    case dieselIZ40     = "dieselIZ40"
    case dieselHeating  = "dieselHeating"
    case lpg            = "lpg"
}
