//
//  DownloadManager.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 30/03/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import Foundation

//! Download manager is singleto designed
class DownloadManager: NSObject {
    
    // MARK: - Initialization 
    
    private static let downloadManagerInstance : DownloadManager = {
        log.verbose("Enter")
        let instance = DownloadManager()
        
        // Here will come configuration, if needed
        return instance
    }()
        
    // let's make contructor private so that it can be used outside of class
    private override init() {}
    
    static func instance() -> DownloadManager {
        log.verbose("Enter")
        return downloadManagerInstance
    }
    
    
    // MARK: - Publicly available methods
    
    func downloadFromUrl(_ url : URL, _ completion : DownloadCompletionClosure?) {
        log.verbose("Enter; url=\(url.absoluteString)")

        let downloadSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
        let task = downloadSession.dataTask(with: url) {
            data, response, error in
            
            if completion != nil {
                
                if data != nil {
                    log.verbose("DATA=\(data!.count)")
                    _ = String(data: data!, encoding: String.Encoding.utf8)
                }
                completion!(data, response, error)
            }
            else {
                log.error("download failed.")
                completion!(data, response, error)
            }
        }
        task.resume()
    }
    
    
}









