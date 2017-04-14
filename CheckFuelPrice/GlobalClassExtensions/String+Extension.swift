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
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "domek", comment: withComment)
    }
    
}

extension String {
    
    func throwException(_ code : Int = 1) -> NSError {
        
        let userInfo = ["error" : self]
        let domain = String(#function) + ":" + String(#line)
        return NSError(domain: domain, code: code, userInfo: userInfo);
    }

}
