//
//  User.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 24/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

struct FuelUser {
    
    let uid : String
    let name : String
    let last_name : String
    let phone : String
    let updated : Int
    
    init(uid : String, name : String, last_name : String,
        phone : String, updated : Int) {
        
        self.uid = uid
        self.name = name
        self.last_name = last_name
        self.phone = phone
        self.updated = updated
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let userAttributes = snapshot.value as? [String : AnyObject] else {
                return nil
        }
        
        self.uid = snapshot.key
        self.name = userAttributes["name"] as! String
        self.last_name = userAttributes["last_name"] as! String
        self.phone = userAttributes["phone"] as! String
        self.updated = userAttributes["updated"] as! Int
        
    }
    
}

