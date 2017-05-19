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
typealias SupplierParseDataCompletionClosure = (ParseDataStatus, [FuelPricesForTheDay]) -> Swift.Void


//! This struct represents prices for all types of fuel for the day
struct FuelPricesForTheDay {
    
    // MARK: Constructors
    init(date : Date) {
        self.date = date
    }
    
    init() {
        self.init(date: Date())
    }
    
    // MARK: Properties
    var date            : Date
    var fuelTypesList   : [CFPFuelType : Double] = [:]
    
    // MARK: Methods
    func getPrice(_ type : CFPFuelType) -> Double {

        guard fuelTypesList[type] != nil  else
        {
            return 0.0
        }
        return fuelTypesList[type]!;
    }
    
    func getAllPrices() -> FuelPricesForTheDay {
        return self
    }
}

protocol CFPFuelSupplierProtocol {
    
    var fuelSupplierName : String {get}
    
    //! Abstracts
    func downloadData(from: URL, completion: @escaping DownloadCompletionClosure) throws

    func parse(_ url : URL, _ html : String, completion: @escaping SupplierParseDataCompletionClosure) throws
    
}

class CFPFuelSupplierSuperClass: CFPFuelSupplierProtocol  {

    var fuelSupplierName: String = ""

    //! MARK: - Download data section
    //! Every subclass needs to populate some webs sites URL here if it wants superclass downloads them
    var webSites : [URL?] = []
    
    //! MARK: - Parsing data
    var parseStatus = ParseDataStatus.succeed
    var parseDataObjectsList : [FuelPricesForTheDay] = []
    
    
    //! MARK: - Interface
    // Need required init for dynamic object class instantiation
    required init() {}
    
    func downloadData(from: URL, completion: @escaping DownloadCompletionClosure) throws {
        log.verbose("Downloading data from: \(from.absoluteString)")
        
        DownloadManager.instance().downloadFromUrl(from, completion)
    }
    
    func parse(_ url: URL, _ html: String, completion: @escaping SupplierParseDataCompletionClosure) throws {
        log.error(CFPErrorType.methodNotOverridden.description)
        throw CFPErrorType.methodNotOverridden
    }

//    func add(fuelPriceForTheDay : FuelPricesForTheDay) throws {
//        
//        if fuelPriceForTheDay.fuelTypesList.count == 0 {
//            log.error("There are no data. Ignore!")
//            self.parseStatus = .brokenData
//            throw CFPErrorType.noData
//        }
//        self.parseDataObjectsList.append(fuelPriceForTheDay)
//    }
    
}


