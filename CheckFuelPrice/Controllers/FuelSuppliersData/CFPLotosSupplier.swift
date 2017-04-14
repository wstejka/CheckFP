//
//  CFPLotosSupplier.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 03/04/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
//
import Foundation
import Kanna

class CFPLotosSupplier : CFPFuelSupplierSuperClass {
        
    required init() {
        log.verbose("Enter")
        super.init()
        self.fuelSupplierName = CFPSuppliersIDs.Lotos.rawValue
        self.webSites.append(URL(string: "http://www.lotos.pl/144/poznaj_lotos/dla_biznesu/hurtowe_ceny_paliw"))
    }
    
    // Added just for debuging purpose
    deinit  {
        log.verbose("")
    }
    
    override func parse(_ url: URL, _ html: String, completion: @escaping SupplierParseDataCompletionClosure) throws {
        log.verbose("Parse")
        
//        Kanna.HTML(html: "test", encoding : String.Encoding.utf8)
        _ = HTML(url: URL(string: "wewfecw")!, encoding: .utf8)
        
        defer { completion(self.parseStatus, self.parseDataObjectsList) }
        

        
    }

}
