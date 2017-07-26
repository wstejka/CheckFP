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
    case users          = "users/profile"
    case userlocation   = "users/location"
    case userSettings   = "users/settings"
    case photoTimestamp = "photoTimestamp"
    case photoReference = "photoReference"
    case fuelPurchase   = "purchases"
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
    private static let fileSizeFactor : Int64 = 1024 * 1024
    // 2 * 1MB
    static let fileSizeLimit : Int64 = 2 * fileSizeFactor

    static let defaultUserPhotoName = "photo.jpg"
    
    // This factor is used to detemine price per one liter as suppliers provide information in 1000L
    static let capacityDividerFactor = 1000.0
    
}

// Important remark: DO NOT modify ordering of items as they must
//                   match the IDs ordering on firebase
enum Fuel : Int {
    case none = 0
    case unleaded95
    case unleaded98
    case diesel
    case dieselIZ40
    case dieselHeating
    case lpg
    
    func getLocalizedText() -> String? {
        
        let handler = String(describing: self)
        return handler.localized().capitalizingFirstLetter()
    }
    
}
// Important remark: DO NOT modify ordering of items as they must
//                   match the IDs ordering on firebase
enum FuelName : String {
    case none           = "none"
    case unleaded95     = "unleaded95"
    case unleaded98     = "unleaded98"
    case diesel         = "diesel"
    case dieselIZ40     = "dieselIZ40"
    case dieselHeating  = "dieselHeating"
    case lpg            = "lpg"
}

enum TimeRanges : String {
    case weekly     = "weekly"
    case monthly    = "monthly"
    case annually   = "annually"
}

enum Supplier : Int {
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
