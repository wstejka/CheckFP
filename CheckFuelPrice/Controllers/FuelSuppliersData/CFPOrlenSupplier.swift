//
//  CFPOrlenSupplier.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 03/04/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
//
import Foundation
import Kanna

class CFPOrlenSupplier : CFPFuelSupplierSuperClass {

    required init() {
        log.verbose("Enter")
        super.init()
        self.fuelSupplierName = CFPSuppliersID.orlen.rawValue
        
        for webSite in iterateEnum(OrlenWebPage.self) {
            self.webSites.append(URL(string: webSite.rawValue))
        }
    }
    
    // Added just for debuging purpose
    deinit  {
        log.verbose("")
    }
    
    enum OrlenWebPage : String {
        case orlenPrimaryWebPage = "http://www.orlen.pl/PL/DlaBiznesu/HurtoweCenyPaliw/Strony/default.aspx"
    }
    
    let OrlenNazwa          = "Nazwa"
    let OrlenCena           = "Cena"
    
    override func parse(_ url: URL, _ html: String, completion: @escaping SupplierParseDataCompletionClosure) throws {
        log.verbose("Parse")
        
        defer { completion(self.parseStatus, self.parseDataObjectsList) }
        
        if url.absoluteString == OrlenWebPage.orlenPrimaryWebPage.rawValue {
            if let doc = HTML(html: html, encoding: .utf8) {
                log.verbose(doc.title!)
                
                var fuelPriceForTheDay = FuelPricesForTheDay()
                
                // Search for nodes by CSS
                for link in doc.css("table[class='tableLight']") {
                    
                    for tr in link.css("\(CFPHtmlSection.tr.rawValue)") {

                        var tagFuelName : CFPFuelType = .none
                        var currentTagFuelName = tagFuelName
                        for td in tr.css(CFPHtmlSection.td.rawValue) {
                            
                            tagFuelName = .none
                            let foundTagName = td.text!
                            if foundTagName.contains("95") {
                                tagFuelName = .unleaded95
                            }
                            else if foundTagName.contains("98") {
                                tagFuelName = .unleaded98
                            }
                            else if foundTagName.contains("Ekodiesel") {
                                tagFuelName = .diesel
                            }
                            else if foundTagName.contains("Arktyczny") {
                                tagFuelName = .dieselIZ40
                            }
                            else if foundTagName.contains("Grzewczy") {
                                tagFuelName = .dieselHeating
                            }

                            if tagFuelName != .none {
                                currentTagFuelName = tagFuelName
                            }
                            else {
                                if currentTagFuelName != .none {
//                                    // First of all let's remove empty chars as data format is e.g. "3 732,00 zł/m3"
                                    var stringTypedFuelPrice = td.text ?? "0.0"
                                    stringTypedFuelPrice = stringTypedFuelPrice.replacingOccurrences(of: "zł/m3", with: "").replacingOccurrences(of: "\u{00A0}", with: "")
                                    fuelPriceForTheDay.fuelTypesList[currentTagFuelName] = (stringTypedFuelPrice as NSString).doubleValue
//                                    for letter in stringTypedFuelPrice.unicodeScalars {
//                                        log.verbose("\(letter.value), isAscii=\(letter.isASCII)")
//                                    }
                                }
                                currentTagFuelName = .none
                            }
                        }
                    }
                }
                self.parseDataObjectsList.append(fuelPriceForTheDay)                
            }
        }
    }

}
