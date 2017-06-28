//
//  UserDefaults+Extension.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 27/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
import SwiftyUserDefaults

extension DefaultsKeys {
    static let lastUserPhotoTimestamp = DefaultsKey<Int?>("lastUserPhotoTimestamp")
    static let lastUserPhotoReference = DefaultsKey<String?>("lastUserPhotoReference")
}
