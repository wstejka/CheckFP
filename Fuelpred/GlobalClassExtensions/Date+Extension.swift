//
//  Date+Extension.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 16/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation



extension Date {
    
    //! This method returns timestamp using time interval since 1970 
    //  Date is narrow down to "dd-MM-YYYY" w/o hours and minutes
    func getSimpleTimestamp() -> Int {
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let stringDate = String(day) + "-" + String(month) + "-" + String(year)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "CET")!
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let simplyfiedDate = dateFormatter.date(from: stringDate)
        
        return Int((simplyfiedDate?.timeIntervalSince1970)!)
        
    }
    
    enum DateFormat {
        case short
        case long
    }
    
    //! This method converts self to date in one of two formats
    func toString(format : DateFormat = .short) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "CET")!
        if format == .short {
            dateFormatter.dateFormat = "dd-MM-yyyy"
        }
        else {
            dateFormatter.dateFormat = "dd-MM-yyyy mm:ss"
        }
        
        return dateFormatter.string(from: self)
    }
    
//    func getFullTimestamp() -> Int {
//        
//    }

}
