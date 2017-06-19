//
//  String+Extension.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 30/03/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation


extension String {

    func localized(withDefaultValue:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: withDefaultValue, comment: "")
    }

    func localized(withComment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "test", comment: withComment)
    }

    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
}

extension String {
    
    func throwException(_ code : Int = 1) -> NSError {
        
        let userInfo = ["error" : self]
        let domain = String(#function) + ":" + String(#line)
        return NSError(domain: domain, code: code, userInfo: userInfo);
    }

}

extension String {

    var length : Int{
        return self.characters.count
    }
    // string[] -> 'character'
    subscript (i: Int) -> String? {
        
        return ((i < self.length) ? self[Range(i ..< i + 1)] : nil)
    }
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
