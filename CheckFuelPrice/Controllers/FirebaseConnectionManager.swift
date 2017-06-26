//
//  FirebaseConnectionManager.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 26/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//


//! FirebaseConnectionManager instance keeps the firebase connection status
class FirebaseConnectionManager {

    // MARK: Constants/Variable
    static var isFirebaseConnected = false
    
    // MARK: Singleton lifecycle
    
    private static var managerInstance: FirebaseConnectionManager = {
        log.verbose("entered")
        // Here ThemesManager is instantatied
        let startTime = Date().timeIntervalSinceNow
        let thisInstance = FirebaseConnectionManager()
        log.verbose("FirebaseConnectionManager instantiated in \((Date().timeIntervalSinceNow - startTime)) secs.")
        
        return thisInstance
    }()
    
    static func instance() -> FirebaseConnectionManager {
        log.verbose("entered")
        
        return FirebaseConnectionManager.managerInstance
    }
    
    // MARK: - Struct object constructor
    
    private init() {
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                log.verbose("Connected")
                FirebaseConnectionManager.isFirebaseConnected = true
            } else {
                log.error("Not connected")
                FirebaseConnectionManager.isFirebaseConnected = false
            }
        })
        
    }

}


