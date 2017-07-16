//
//  Utils.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 28/05/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//


class Utils {
    
    static func getUniqueId() -> String {
        
        let uuid = NSUUID().uuidString
        log.verbose("uid: \(uuid)")
        return uuid
    }
    
    // This method let pass params to
    static func invokeAfter(delay: Int, params : [String : String], execute: @escaping (_ params : [String : String]) -> Void) {

        DispatchQueue.global().async {
            sleep(UInt32(delay))
            
            DispatchQueue.main.async {
                execute(params)
            }
        }
    }
    
    enum TableSections : Int {
        case header
        case body
        case footer
    }
    
    static func setupFuelType(type: Int, inView: FuelTypeView) {

        guard let fuelType = Fuel(rawValue: type) else {
            log.error("Could not instatiate Fuel object for \(type) value")
            return
        }        
        
        let color = ThemesManager.getFuelColor(forFuelType: type)
        inView.backgroundColor = color
        inView.mainText.textColor = .white
        inView.detailText.textColor = .white
        inView.detailText.text = ""
        
        switch fuelType {
        case .unleaded95:
            inView.mainText.text = "95"
        case .unleaded98:
            inView.mainText.text = "98"
        case .diesel:
            inView.mainText.text = "Diesel"
        case .dieselIZ40:
            inView.mainText.text = "Diesel"
            inView.detailText.text = "Super"
        case .dieselHeating:
            inView.mainText.text = "Diesel"
            inView.detailText.text = "heat".localized()
        default:
            inView.mainText.text = "Undefined"
        }
        
    }
}
