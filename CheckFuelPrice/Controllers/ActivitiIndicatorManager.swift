//
//  ActivitiIndicatorManager.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 23/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
import EZLoadingActivity

// This class extends EZLoadingActivity functionallity
struct ActivitiIndicatorManager {
    
    // MARK: Singleton lifecycle
    
    private static var ActivitiIndicatorManagerInstance: ActivitiIndicatorManager = {
        log.verbose("entered")
        // Here ActivitiIndicatorManager is instantatied
        let startTime = Date().timeIntervalSinceNow
        let thisInstance = ActivitiIndicatorManager()
        log.verbose("ActivitiIndicatorManager instantiated in \((Date().timeIntervalSinceNow - startTime)) secs.")
        EZLoadingActivity.Settings.ActivityWidth = activityWidth
        EZLoadingActivity.Settings.ActivityHeight = activityHeight
        EZLoadingActivity.Settings.SuccessText = "success".localized().capitalizingFirstLetter()
        EZLoadingActivity.Settings.FailText = "fail".localized().capitalizingFirstLetter()
        
        return thisInstance
    }()
    
    static func instance() -> ActivitiIndicatorManager {
        log.verbose("entered")
        
        return ActivitiIndicatorManager.ActivitiIndicatorManagerInstance
    }
    
    // MARK: Variables/Constants
    static var inProgress = false
    
    enum Status {
        case success
        case fail
        case immediate
        case delayed
    }
    
    private static let successIcon = EZLoadingActivity.Settings.SuccessIcon
    private static let failIcon = EZLoadingActivity.Settings.FailIcon
    
    private static var uuid = Utils.getUniqueId()
    
    private static let activityWidth : CGFloat = 120.0
    private static let activityHeight : CGFloat = 60.0
    
    // MARK: - Struct object constructor
    private init() {
    }
    
    // MARK: - Methods
    
    func start(with delay: Double) {
        
        log.verbose("entered")

        ActivitiIndicatorManager.uuid = Utils.getUniqueId()
        ActivitiIndicatorManager.inProgress = true
        let loadingText = "loading".localized().capitalizingFirstLetter() + "..."
        _ = EZLoadingActivity.show(loadingText, disableUI: false)
        if delay != 0.0 {
            let params = ["uid" : ActivitiIndicatorManager.uuid]
            Utils.invokeAfter(delay: 3, params: params, execute: { (dict) in
                
                guard let olduid = dict["uid"] else {
                    return
                }
                
                if olduid != ActivitiIndicatorManager.uuid {
                    log.verbose("uid different than expected: \"\(olduid)\" vs. \"\(ActivitiIndicatorManager.uuid)\". Ignoring it.")
                    return
                }
                self.stop(with: .delayed)
            })
        }
    }
    
    func stop(with status: Status = .immediate) {
        log.verbose("entered")

        switch status {
        case .success:
            _ = EZLoadingActivity.hide(success: true, animated: true)
        case .fail:
            _ = EZLoadingActivity.hide(success: false, animated: true)
        case .immediate:
            _ = EZLoadingActivity.hide()
        case .delayed:
            if ActivitiIndicatorManager.inProgress == true {
                _ = EZLoadingActivity.hide()
            }
            else {
                _ = EZLoadingActivity.hide(success: false, animated: true)
            }
            
            break
        }
        ActivitiIndicatorManager.inProgress = false
    }
}

