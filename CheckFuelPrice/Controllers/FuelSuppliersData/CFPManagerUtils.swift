//
//  CFPFuelSupplierUtils.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 03/04/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation

// MARK: - Fuel types

enum CFPFuelTypes : Int {
    
    case CFPFuelTypeUnleaded95
    case CFPFuelTypeUnleaded98
    case CFPFuelTypeDiesel
    case CFPFuelTypeLPG
}

// MARK: - Errors for exception throwing types

enum CFPErrorTypes : Error {
    case CFPErrorTypeUnknown
    case CFPErrorTypeGeneral
    case CFPErrorTypeMethodNotOverridden
    case CFPErrorTypeDownloadFailed
    case CFPErrorTypeNoData
    case CFPErrorTypeBadResponseCode
    
}

extension CFPErrorTypes : CustomStringConvertible {
    
    var description: String {
        
        switch self {
        case .CFPErrorTypeUnknown:
            return "Unknown error."
        case .CFPErrorTypeGeneral:
            return "General error."
        case .CFPErrorTypeMethodNotOverridden:
            return "This is an abstraction. This method must be overridden in subclass."
        case .CFPErrorTypeDownloadFailed:
            return "Download failed"
        case .CFPErrorTypeNoData:
            return "No data"
        case .CFPErrorTypeBadResponseCode:
            return "Response code not equal 200"
        }
    }
}

// MARK: - Suppliers' identities

enum CFPSuppliersIDs : String {
    case None       = "NONE"
    case Orlen      = "ORLEN"
    case Lotos      = "LOTOS"
}


enum ParseDataStatus {
    case PDSParseDataStatusSucceed
    case PDSParseDataStatusBrokenData
    case PDSParseDataStatusLackOfData
    case PDSParseDataStatusUknownError
}


func invokeEnclosureOnError(_ completion : SupplierParseDataCompletionClosure?,
                            _ status : ParseDataStatus,
                            _ text : String) {
    log.verbose(text)

    if completion == nil {
        log.error("Closure is empty. Ignoring ...")
    }
    completion!(status, [])
}


// Swift 3
func synchronized<T>(_ lock: AnyObject, _ body: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try body()
}
