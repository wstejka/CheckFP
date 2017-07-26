//
//  User.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 24/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//


// MARK: - Fuel user profile
struct FuelUserProfile {
    
    var uid : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var phone : String = ""
    var updated : Int = 0
    // reference to user's photo e.g.: unique_id_photo.jpg
    var photoReference : String = ""
    var photoTimestamp : Int = 0
    
    
    init() {
    
        self.init(uid: "", firstName: "", lastName: "", phone: "", updated: 0, photoReference: "", photoTimestamp: 0)
    }
    
    init(uid : String, firstName : String, lastName : String,
         phone : String, updated : Int, photoReference : String,
         photoTimestamp : Int) {
        
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.updated = updated
        self.photoReference = photoReference
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
        if let photoReference = userAttributes["photoReference"] as? String {
            self.photoReference = photoReference
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
            "photoReference" : photoReference,
            "photoTimestamp" : photoTimestamp,
        ]
    }
    
}

// MARK: Fuel user location
struct FuelUserLocation {
    
    
    var uid: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var name : String = ""
    var city : String = ""
    var state : String = ""
    
    init() {
        
        self.init(latitude: 0.0, longitude: 0.0, name : "", city : "", state : "")
    }
    
    init(latitude: Double, longitude: Double, name: String, city: String, state: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.city = city
        self.state = state
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let userAttributes = snapshot.value as? [String : AnyObject] else {
            return nil
        }
        
        self.uid = snapshot.key
        if let latitude = userAttributes["latitude"] as? Double {
            self.latitude = latitude
        }
        if let longitude = userAttributes["longitude"] as? Double {
            self.longitude = longitude
        }
        if let name = userAttributes["Name"] as? String {
            self.name = name
        }
        if let city = userAttributes["City"] as? String {
            self.city = city
        }
        if let state = userAttributes["State"] as? String {
            self.state = state
        }
    }
    
    func toAnyObject() -> Any {
        return [
            "latitude" : latitude,
            "longitude" : longitude,
            "Name" : name,
            "City" : city,
            "State" : state,
        ]
    }
    
}



