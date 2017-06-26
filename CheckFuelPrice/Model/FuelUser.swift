//
//  User.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 24/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

struct FuelUser {
    
    let uid : String
    var firstName : String = ""
    var lastName : String = ""
    var phone : String = ""
    var updated : Int = 0
    // reference to user's photo e.g.: users/UCPdi7Hto3Q7QRdX5ShDgSqJwB63/unique_id_photo.jpg
    var photoReference : String = ""
    var photoTimestamp : Int = 0
    
    init(uid : String, firstName : String, lastName : String,
         phone : String, updated : Int, photoRefence : String,
         photoTimestamp : Int) {
        
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.updated = updated
        self.photoReference = photoRefence
        self.photoTimestamp = photoTimestamp
        
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let userAttributes = snapshot.value as? [String : AnyObject] else {
                return nil
        }
        
        self.uid = snapshot.key
        if let firstName = userAttributes["firstName"] as? String {
            self.firstName = firstName
        }
        if let lastName = userAttributes["lastName"] as? String {
            self.lastName = lastName
        }
        if let phone = userAttributes["phone"] as? String {
            self.phone = phone
        }
        if let updated = userAttributes["updated"] as? Int {
            self.updated = updated
        }
        if let photoRefence = userAttributes["photoRefence"] as? String {
            self.photoReference = photoRefence
        }
        if let photoTimestamp = userAttributes["photoTimestamp"] as? Int {
            self.photoTimestamp = photoTimestamp
        }
        
    }
    
    func toAnyObject() -> Any {
        return [
            "firstName": firstName,
            "lastName": lastName,
            "phone" : phone,
            "updated": updated,
            "uid" : uid,
            "photoRefence" : photoReference,
            "photoTimestamp" : photoTimestamp,
        ]
    }
    
}

