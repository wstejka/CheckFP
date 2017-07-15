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
    
    static func setupFuelType(view: FuelTypeView, forType: Int) {

        guard let fuelType = Fuel(rawValue: forType) else {
            log.error("Could not instatiate Fuel object for \(forType) value")
            return
        }        
        
        let color = ThemesManager.getFuelColor(forFuelType: forType)
        view.backgroundColor = color
        view.mainText.textColor = .white
        view.detailText.textColor = .white
        view.detailText.text = ""
        
        switch fuelType {
        case .unleaded95:
            view.mainText.text = "95"
        case .unleaded98:
            view.mainText.text = "98"
        case .diesel:
            view.mainText.text = "Diesel"
        case .dieselIZ40:
            view.mainText.text = "Diesel"
            view.detailText.text = "Super"
        case .dieselHeating:
            view.mainText.text = "Diesel"
            view.detailText.text = "heat".localized()
        default:
            view.mainText.text = "Undefined"
        }
        
    }
}
