//
//  CFPOrlenSupplier.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 03/04/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
//
import Foundation

class CFPOrlenSupplier : CFPFuelSupplierSuperClass {

    required init() {
        log.verbose("Enter")
        super.init()
        self.fuelSupplierName = CFPSuppliersIDs.Orlen.rawValue
        self.webSites.append(URL(string: "http://www.orlen.pl/PL/DlaBiznesu/HurtoweCenyPaliw/Strony/default.aspx"))
    }
    
    // Added just for debuging purpose
    deinit  {
        log.verbose("")
    }
    
    func callAfterProcessing() {
        log.verbose("Hurrraaa")
    }
    
    override func parse(_ url: URL, _ html: String, completion: @escaping SupplierParseDataCompletionClosure) throws {
        log.verbose("Parse")
        
        defer { completion(self.parseStatus, self.parseDataObjectsList) }
        
    }
}
