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
    case photoTimestamp = "photoTimestamp"
}

enum FirebaseStorageNode : String {
    case users  =   "users"
}

enum FirebaseStorageFileCompressionLevel : CGFloat {
    
    case veryhigh       = 0.0
    case high           = 0.3
    case medium         = 0.5
    case low            = 0.7
    case nocompression  = 1.0
}

// TODO: This data need to be obtain from Firebase DB
enum CountryVat : Double {
    case poland = 23.0
}

struct FirebaseUtils {
    
    // 1MB
    private static let fileSizeFactor : UInt64 = 1024 * 1024
    // 2 * 1MB
    static let fileSizeLimit : UInt64 = 2 * fileSizeFactor

    static let defaultPhotoUserName = "photo.jpg"
    
}
