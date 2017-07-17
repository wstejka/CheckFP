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
 
//        log.verbose("\(Thread.isMainThread)")
        synchronized(self) {
            let _ = self.userConfig
        }
        return userConfig
    }
    
    static func compute(fromValue value : Double) -> Double {
    
        let config = self.getUserConfig()
        var vatValueFactor : Double = 1.0
        if config.vatIncluded == 0 {
            vatValueFactor = vatValueFactor + Double(config.vatAmount / 100)
        }
        var fuelCapacityFactor : Double = 1.0
        let fuelUnit = FuelUnit(rawValue: config.capacity)
        if fuelUnit == .thousandLiters {
            fuelCapacityFactor = 1000.0
        }
        let computedValue = (value / fuelCapacityFactor) * vatValueFactor

        return computedValue
    }
    
}
