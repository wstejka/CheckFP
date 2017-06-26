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
    case users          = "users"
}

enum FirebaseStorageNode : String {
    case users  =   "users"
}


// TODO: This data need to be obtain from Firebase DB
enum CountryVat : Double {
    case poland = 23.0
}

struct FirebaseStorage {
    
    // 1MB
    private static let fileSizeFactor : UInt64 = 1024 * 1024
    // 2 * 1MB
    static let fileSizeLimit : UInt64 = 2 * fileSizeFactor
}
