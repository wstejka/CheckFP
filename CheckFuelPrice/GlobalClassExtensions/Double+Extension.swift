//
//  Double+Extension.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 28/05/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

enum DateFormat {
    case short
    case long
}

//! This method converts given timestamp to date in one of two formats
extension Double {
    
    func timestampToString(format : DateFormat = .short) -> String {
        
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "CET")!
        if format == .short {
            dateFormatter.dateFormat = "dd-MM-yyyy"
        }
        else {
            dateFormatter.dateFormat = "dd-MM-yyyy mm:ss"
        }
        
        return dateFormatter.string(from: date)
    }
}

extension Double {
    
    func round(to places: Int) -> Double {
        // First use string to format data accordingly
        let roundedString = String(format: "%.\(places)f", self)
        // And now cast it back to float
        guard let rounded = Double(roundedString) else {
            // could not cast value properly. Let's return original value
            return self
        }
        return rounded
    }

    func strRound(to places: Int) -> String {
        
        return String(format: "%.\(places)f", self)
    }
}
