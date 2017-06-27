//
//  Utils.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 28/05/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//


class Utils {
    
    static func getUniqueId() -> String {
        
        let uuid = NSUUID().uuidString
        log.verbose("uid: \(uuid)")
        return uuid
    }
    
    // This method let pass params to
    static func invokeAfter(delay: Int, params : [String : String], execute: @escaping (_ params : [String : String]) -> Void) {

        DispatchQueue.global().async {
            sleep(UInt32(delay))
            
            DispatchQueue.main.async {
                execute(params)
            }
        }
    }
    
}
