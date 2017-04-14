//
//  CFPFuelSupplierPrototype.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 01/04/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
//
import Foundation

//! Let's define closures alias here for simplicity
typealias SupplierParseDataCompletionClosure = (ParseDataStatus, [FuelPricesForTheDay]?) -> Swift.Void


//! This struct represents prices for all types of fuel for the day
struct FuelPricesForTheDay {
    
    var date            : Date
    var unleaded95Price : Double
    var unleaded98Price : Double
    var dieselPrice     : Double
    var lpgPrice        : Double
    
    func getPrice(_ type : CFPFuelTypes) -> Double {
        
        switch type {
        case CFPFuelTypes.CFPFuelTypeUnleaded95:
            return self.unleaded95Price
        case CFPFuelTypes.CFPFuelTypeUnleaded98:
            return self.unleaded98Price
        case CFPFuelTypes.CFPFuelTypeDiesel:
            return self.dieselPrice
        case CFPFuelTypes.CFPFuelTypeLPG:
            return self.lpgPrice
        }
    }
    
    func getAllPrices() -> FuelPricesForTheDay {
        return self
    }
}

protocol CFPFuelSupplierPrototype {
    
    var fuelSupplierName : String {get}
    
    //! Abstracts
    func downloadData(from: URL, completion: @escaping DownloadCompletionClosure) throws

    func parse(_ url : URL, _ html : String, completion: @escaping SupplierParseDataCompletionClosure) throws
    
}

class CFPFuelSupplierSuperClass: CFPFuelSupplierPrototype  {

    var fuelSupplierName: String = ""

    //! MARK: - Download data section
    //! Every subclass needs to populate some webs sites URL here if it wants superclass downloads them
    var webSites = [URL?]()
    
    //! MARK: - Parsing data
    var parseStatus = ParseDataStatus.PDSParseDataStatusSucceed
    var parseDataObjectsList : [FuelPricesForTheDay]?
    
    
    //! MARK: - Interface
    // Need required init for dynamic object class instantiation
    required init() {}
    
    func downloadData(from: URL, completion: @escaping DownloadCompletionClosure) throws {
        log.verbose("Downloading data from: \(from.absoluteString)")
        
        DownloadManager.instance().downloadFromUrl(from, completion)
    }
    
    func parse(_ url: URL, _ html: String, completion: @escaping SupplierParseDataCompletionClosure) throws {
        log.error(CFPErrorTypes.CFPErrorTypeMethodNotOverridden.description)
        throw CFPErrorTypes.CFPErrorTypeMethodNotOverridden
    }

}


