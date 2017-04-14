//
//  CFPFuelSupplierUtils.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 03/04/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation

// MARK: - Fuel types

enum CFPFuelType : Int {
    
    case none
    case unleaded95
    case unleaded98
    case diesel
    case dieselIZ40
    case lpg
}

// MARK: - Errors for exception throwing types

enum CFPErrorType : Error {
    case unknown
    case general
    case methodNotOverridden
    case downloadFailed
    case noData
    case badResponseCode
    
}

enum CFPHtmlSection : String {
    case td = "td"
    case tr = "tr"
    case th = "th"
}

extension CFPErrorType : CustomStringConvertible {
    
    var description: String {
        
        switch self {
        case .unknown:
            return "Unknown error."
        case .general:
            return "General error."
        case .methodNotOverridden:
            return "This is an abstraction. This method must be overridden in subclass."
        case .downloadFailed:
            return "Download failed"
        case .noData:
            return "No data"
        case .badResponseCode:
            return "Response code not equal 200"
        }
    }
}

// MARK: - Suppliers' identities

enum CFPSuppliersID : String {
    case none       = "NONE"
    case orlen      = "ORLEN"
    case lotos      = "LOTOS"
}


enum ParseDataStatus {
    case succeed
    case brokenData
    case lackOfData
    case uknownError
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

