//
//  UserConfigurationManager.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 16/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation

//! UserConfigurationManager instance keeps the user's configuration data
class UserConfigurationManager {
    
    // MARK: Constants/Variable
    fileprivate static var userConfig = UserConfig()
    
    // MARK: Singleton lifecycle
    
    private static var managerInstance: UserConfigurationManager = {
        log.verbose("entered")
        // Here ThemesManager is instantatied
        let startTime = Date().timeIntervalSinceNow
        let thisInstance = UserConfigurationManager()
        log.verbose("UserConfigurationManager instantiated in \((Date().timeIntervalSinceNow - startTime)) secs.")
        
        return thisInstance
    }()
    
    static func instance() -> UserConfigurationManager {
        log.verbose("entered")
        
        return UserConfigurationManager.managerInstance
    }
    
    // MARK: - Struct object constructor
    
    private init() {
        
        log.verbose("\(Thread.isMainThread)")

        // Firebase uid
        guard let uid = Auth.auth().currentUser?.uid else {
            log.error("This user is not authenticated.")
            return
        }
        let connectedRef = Database.database().reference(withPath: FirebaseNode.userSettings.rawValue)
        connectedRef.child(uid).observe(.value, with: { snapshot in

            DispatchQueue.global().async {
                log.verbose("\(Thread.isMainThread)")
                
                synchronized(self) {
                    log.verbose("Current user's configuration \(snapshot)")
                    guard let userConfigFromSnapshot = UserConfig(snapshot: snapshot) else {
                        log.error("Cannot extract data from snapshot")
                        return
                    }
                    type(of: self).userConfig = userConfigFromSnapshot
                }
            }
        })
    }
    
    // MARK: - Methods
    
    static func getUserConfig() -> UserConfig {
 
        synchronized(self) {
            let _ = self.userConfig
        }
        return userConfig
    }
    
    //! This method is used to compute prices depends on configuration settings
    static func compute(fromValue value : Double, fuelType: Fuel = .none, includeVat : Bool = true) -> Double {
    
        let config = self.getUserConfig()
        var fuelMarginFactor : Double = 1.0
        var vatValueFactor : Double = 1.0
        if (includeVat == true) &&
            (config.vatIncluded == true) {
            vatValueFactor = vatValueFactor + Double(config.vatAmount / 100)
            
            var margin = 0.0
            switch fuelType {
            case .unleaded95:
                margin = Double(config.unleaded95Margin)
            case .unleaded98:
                margin = Double(config.unleaded98Margin)
            case .diesel:
                margin = Double(config.dieselMargin)
            case .dieselIZ40:
                margin = Double(config.dieselPremiumMargin)
            case .dieselHeating:
                margin = Double(config.dieselHeatingMargin)
            default:
                margin = 0.0
            }
            fuelMarginFactor = Double(1.0 + (margin / 100))
        }
        var fuelCapacityFactor : Double = 1.0
        let fuelUnit = FuelUnit(rawValue: config.capacity)
        if fuelUnit == .oneLiter {
            fuelCapacityFactor = FirebaseUtils.capacityDividerFactor
        }
        let computedValue = (value / fuelCapacityFactor) * fuelMarginFactor * vatValueFactor

        return computedValue
    }
    
}
