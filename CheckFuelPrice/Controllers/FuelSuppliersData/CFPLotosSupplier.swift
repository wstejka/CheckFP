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
   
        for webSite in iterateEnum(LotosWebPage.self) {
            self.webSites.append(URL(string: webSite.rawValue))
        }
    }
    
    // Added just for debuging purpose
    deinit  {
        log.verbose("")
    }
    
    enum LotosWebPage : String {
        case lotosPrimaryWebPage = "http://www.lotos.pl/144/poznaj_lotos/dla_biznesu/hurtowe_ceny_paliw"
    }
    
    let lotosPaliwo         = "Paliwo"
    let lotosCena           = "Cena"
    let lotosAkcyza         = "Akcyza"
    let lotosOplataPaliwowa = "Opłata paliwowa"
    
    
    override func parse(_ url: URL, _ html: String, completion: @escaping SupplierParseDataCompletionClosure) throws {
        log.verbose("Parse")

        defer { completion(self.parseStatus, self.parseDataObjectsList) }

        if url.absoluteString == LotosWebPage.lotosPrimaryWebPage.rawValue {
            if let doc = HTML(html: html, encoding: .utf8) {
                log.verbose(doc.title!)
                
                var fuelPriceForTheDay = FuelPricesForTheDay()
                
                // Search for nodes by CSS
                for link in doc.css("table") {

                    // Look for TH tags as these contains headers which let distinguish data sections
                    let theXPathObject = link.css(CFPHtmlSection.CFPHTMLSecionTH.rawValue)

                    if (theXPathObject.count == 2) &&
                        (theXPathObject[0].text == lotosPaliwo) &&
                        (theXPathObject[1].text == lotosCena) {

                        for tr in link.css(CFPHtmlSection.CFPHTMLSecionTR.rawValue) {
                            var tagFuelName : CFPFuelTypes = .CFPFuelTypeNone
                            var currentTagFuelName = tagFuelName
                            for td in tr.css(CFPHtmlSection.CFPHTMLSecionTD.rawValue) {                                
                                tagFuelName = .CFPFuelTypeNone
                                let foundTagName = td.text!
                                if foundTagName.contains("95") {
                                    tagFuelName = .CFPFuelTypeUnleaded95
                                }
                                else if foundTagName.contains("98") {
                                    tagFuelName = .CFPFuelTypeUnleaded98
                                }
                                else if foundTagName.contains("EURODIESEL") {
                                    tagFuelName = .CFPFuelTypeDiesel
                                }
                                else if foundTagName.contains("40") {
                                    tagFuelName = .CFPFuelTypeDieselIZ40
                                }
                                
                                if tagFuelName != .CFPFuelTypeNone {
                                    currentTagFuelName = tagFuelName
                                }
                                else {
                                    if currentTagFuelName != .CFPFuelTypeNone {
                                        // First of all let's remove empty chars as data format is e.g. "3 732,00"
                                        var stringTypedFuelPrice = td.text ?? "0.0"
                                        stringTypedFuelPrice = stringTypedFuelPrice.replacingOccurrences(of: " ", with: "")
                                        fuelPriceForTheDay.fuelTypesList[currentTagFuelName] = (stringTypedFuelPrice as NSString).doubleValue
                                    }
                                    currentTagFuelName = .CFPFuelTypeNone
                                }
                            }
                        }
                    }
                }
                if fuelPriceForTheDay.fuelTypesList.count == 0 {
                    log.error("Were not able to parse data from web site!")
                    self.parseStatus = .PDSParseDataStatusBrokenData
                    return
                }
                self.parseDataObjectsList?.append(fuelPriceForTheDay)
            }
        }
    }

}
