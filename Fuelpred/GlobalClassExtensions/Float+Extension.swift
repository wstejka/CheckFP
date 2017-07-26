//
//  Float+Extension.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 09/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

extension Float {
    
    func round(to places: Int) -> Float {
        // First use string to format data accordingly
        let roundedString = String(format: "%.\(places)f", self)
        // And now cast it back to float
        guard let rounded = Float(roundedString) else {
            // could not cast value properly. Let's return original value
            return self
        }
        return rounded
    }
    
    func strRound(to places: Int) -> String {
        
        return String(format: "%.\(places)f", self)
    }
}
