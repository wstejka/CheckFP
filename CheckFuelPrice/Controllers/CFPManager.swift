//
//  CFPManager.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 04/04/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation

class CFPManager {
    
    let fuelSupplierSuperClassType = CFPFuelSupplierSuperClass.self
    
    // MARK: init
    private static let cfpInstance : CFPManager = {
        log.verbose("Enter")
        let cfpManager = CFPManager()
        
        // Here CFPManager is instantatied so we can call instance method (non static)
        // Let's request for suppliers list
        cfpManager.fuelSupplierList = cfpManager.getFuelSuppliersList()
        
        return cfpManager
    }()
    
    // Let's make init private so that it cannot be used
    private init(){}
    
    static func instance() -> CFPManager {
        log.verbose("Enter")
        let startTime = Date().timeIntervalSinceNow
        let cfpManager = cfpInstance
        let processingTime = (Date().timeIntervalSinceNow - startTime)
        log.verbose("CFPManager instantiated in \(processingTime) secs.")
        return cfpManager
    }
    
    
    // MARK: - static functions and properties
    
    private var fuelSupplierList : [CFPFuelSupplierSuperClass.Type]?
    
    // It returns the suppliers type list
    // As it is time consuming let's control it internally
    private func getFuelSuppliersList() -> [CFPFuelSupplierSuperClass.Type] {
     
            log.verbose("Enter")
            return getSubclassesInherited(fromSuperClass: fuelSupplierSuperClassType)
    }
    
    private func getSubclassesInherited(fromSuperClass : CFPFuelSupplierSuperClass.Type) -> [CFPFuelSupplierSuperClass.Type] {
        
        // Code partially borrowed from https://gist.github.com/bnickel/410a1bdc02f12fbd9b5e
        let expectedClassCount = objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass?>(allClasses)
        let actualClassCount:Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)
        
        var classes = [CFPFuelSupplierSuperClass.Type]()
        for i in 0 ..< actualClassCount {
            if let currentClass: AnyClass = allClasses[Int(i)] {
                
                var currentAuxClass : AnyClass? = currentClass
                repeat {
                    currentAuxClass = class_getSuperclass(currentAuxClass)
                    if  fromSuperClass == currentAuxClass {
                        
                        // Cast object to custom type
                        let supplierClassType = currentClass as! CFPFuelSupplierSuperClass.Type
                        // put it on the queue
                        classes.append(supplierClassType)
                        log.verbose("\(currentClass) inherits from \(fromSuperClass). Let's add it to the list.")
                    }
                } while (currentAuxClass != nil)
            }
        }
        log.verbose("Number of classes: \(classes.count)")
        allClasses.deallocate(capacity: Int(expectedClassCount))
        
        return classes
    }
    
    // MARK: - public functions
    func getInstanceOf(supplier: CFPFuelSupplierSuperClass.Type) -> CFPFuelSupplierSuperClass {
        log.verbose("Returning \(String(describing: supplier)) instance.")
        return supplier.init()
    }
    
    func getAllSuppliersInstanceList() -> [CFPFuelSupplierSuperClass] {
        
        var allSuppliersInstanceList = [CFPFuelSupplierSuperClass]()
        for supplier in self.fuelSupplierList! {
            
            allSuppliersInstanceList.append(supplier.init())
        }
        log.verbose("Returning \(String(describing: allSuppliersInstanceList))")
        return allSuppliersInstanceList
    }
        
    func provisionData(){
        log.verbose("Enter")
        
        DispatchQueue.global().async {
            // STEP 1: Go throughout all suppliers objects
            for supplier in self.getAllSuppliersInstanceList() {
                
                // STEP 2: For each supplier download all websites linked with them
                for url in supplier.webSites {
                    
                    do {
                        // STEP 3: Download web site with data for specific URL
                        // Download data is a wrapper on URLSession so it is done async already
                        // This is common for all suppliers so implemetation is provided by the superclass
                        try supplier.downloadData(from: url!, completion: {
                            (data, response, error) in
                            
                            // STEP 4: parse data asynchronically
                            // This step is specific for every supplier. So, each supplier class make a parse by itself
                            self.concurrentBackgroundQeueue.async {
                                do {
                                    // let's check data are not nil
                                    guard (data != nil) else {
                                        throw CFPErrorType.noData
                                    }
                                    // ... and then let's check respone status is 200
                                    let httpResponse = response as! HTTPURLResponse
                                    guard httpResponse.statusCode == 200 else {
                                        throw CFPErrorType.badResponseCode
                                    }
                                    
                                    // For convenience let's create new supplier's instance for parsing and saving actions
                                    // It means there are n+1 instances of any supplier, where n is a number of web pages for processing
                                    let supplierForParsing = self.getInstanceOf(supplier: type(of: supplier))
                                    
                                    let stringData = String(data: data!, encoding: String.Encoding.utf8)
                                    try supplierForParsing.parse(url!, stringData!, completion: {
                                        (parsedDataStatus, fuelPricesForTheDayList) in
                                        
                                    })
                                }
                                catch let error as CFPErrorType {
                                    log.error("Error captured: \(error.description)")
                                }
                                catch {
                                    log.error("Error captured while parsing")
                                }
                            }
                        })
                    }
                    catch {
                        log.error("Error captured during downloading data")
                    }
                }
            }
        }
    }
    
    
    // MARK: - custom serial queue
    var serialBackgroundQeueue = DispatchQueue(label: "CFP Serial background queue")
    var concurrentBackgroundQeueue = DispatchQueue(label: "CFP Concurrent background queue", attributes: .concurrent)
    
    
}









