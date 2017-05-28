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
            dateFormatter.dateFormat = "dd-MM-YYYY"
        }
        else {
            dateFormatter.dateFormat = "dd-MM-YYYY mm:ss"
        }
        
        return dateFormatter.string(from: date)
    }
}

