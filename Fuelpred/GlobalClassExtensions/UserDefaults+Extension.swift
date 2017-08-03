//
//  UserDefaults+Extension.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 27/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
import SwiftyUserDefaults

extension DefaultsKeys {
    static let isAuthenticated = DefaultsKey<Bool?>("isAuthenticated")

    static let lastUserPhotoTimestamp = DefaultsKey<Int?>("lastUserPhotoTimestamp")
    static let lastUserPhotoReference = DefaultsKey<String?>("lastUserPhotoReference")
    
    // User's settings
    static let currentTheme = DefaultsKey<Int?>("currentTheme")
    static let currentSuplier = DefaultsKey<Int?>("currentSuplier")
    static let currentDefaultCapacity = DefaultsKey<Int?>("currentDefaultCapacity")
    static let currentIncludeVat = DefaultsKey<Bool?>("currentIncludeVat")
    static let currentVatTaxAmount = DefaultsKey<Double?>("currentVatTaxAmount")
    static let currentUnleaded95Margin = DefaultsKey<Double?>("currentUnleaded95Margin")
    static let currentUnleaded98Margin = DefaultsKey<Double?>("currentUnleaded98Margin")
    static let currentDieselMargin = DefaultsKey<Double?>("currentDieselMargin")
    static let currentDieselSuperMargin = DefaultsKey<Double?>("currentDieselSuperMargin")
    static let currentDieselHeatingMargin = DefaultsKey<Double?>("currentDieselHeatingMargin")
}
