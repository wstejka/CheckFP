//
//  User.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 24/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    init() {}
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

struct FuelUser {
    
    var uid : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var phone : String = ""
    var updated : Int = 0
    // reference to user's photo e.g.: users/UCPdi7Hto3Q7QRdX5ShDgSqJwB63/unique_id_photo.jpg
    var photoReference : String = ""
    var photoTimestamp : Int = 0
    
    init() {
    
        self.init(uid: "", firstName: "", lastName: "", phone: "", updated: 0, photoReference: "", photoTimestamp: 1)
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

