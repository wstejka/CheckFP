//
//  CFPUtils.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 30/03/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation


enum CFPDownloadStatus : Int {

    case CFPDownloadStatusUnknown
    case CFPDownloadStatusOK
    case CFPDownloadStatusFailed
}


//! Let's define closures alias here for simplicity
typealias DownloadCompletionClosure = (Data?, URLResponse?, Error?) -> Swift.Void

