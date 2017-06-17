//
//  FirebaseUtils.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

enum FirebaseNode : String {
    case fuelType       = "fuel_types"
    case fuelPriceItem  = "fuel_price_items"
}

// TODO: This data need to be obtain from Firebase DB
enum CountryVat : Double {
    case poland = 23.0
}
