//
//  UserConfig.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 02/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

// MARK: Fuel user location
struct UserConfig {
    
    var uid : String = ""
    var theme : Int = ThemesManager.Theme.basic.rawValue
    var supplier: Int = Supplier.none.rawValue
    var vatIncluded: Bool = true
    var vatAmount: Float = 23.0
    var capacity : Int = FuelUnit.oneLiter.rawValue
    var unleaded95Margin: Float = 5.0
    var unleaded98Margin: Float = 5.0
    var dieselMargin: Float = 5.0
    var dieselPremiumMargin: Float = 5.0
    var dieselHeatingMargin: Float = 5.0
    
    init() {
    }
    
    init(theme : Int, supplier: Int, vatIncluded: Bool, vatAmount: Float,
         capacity: Int, unleaded95Margin: Float, unleaded98Margin: Float, dieselMargin: Float,
         dieselPremiumMargin: Float, dieselHeatingMargin: Float) {
        
        self.theme = theme
        self.supplier = supplier
        self.vatIncluded = vatIncluded
        self.vatAmount = vatAmount
        self.capacity = capacity
        self.unleaded95Margin = unleaded95Margin
        self.unleaded98Margin = unleaded98Margin
        self.dieselMargin = dieselMargin
        self.dieselPremiumMargin = dieselPremiumMargin
        self.dieselHeatingMargin = dieselHeatingMargin
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let userConfiguration = snapshot.value as? [String : AnyObject] else {
            return nil
        }
        
        self.uid = snapshot.key
        if let theme = userConfiguration["theme"] as? Int {
            self.theme = theme
        }
        if let supplier = userConfiguration["supplier"] as? Int {
            self.supplier = supplier
        }
        if let vatIncluded = userConfiguration["vatIncluded"] as? Bool {
            self.vatIncluded = vatIncluded
        }
        if let vatAmount = userConfiguration["vatAmount"] as? Float {
            self.vatAmount = vatAmount
        }
        if let capacity = userConfiguration["capacity"] as? Int {
            self.capacity = capacity
        }
        if let unleaded95Margin = userConfiguration["unleaded95Margin"] as? Float {
            self.unleaded95Margin = unleaded95Margin
        }
        if let unleaded98Margin = userConfiguration["unleaded98Margin"] as? Float {
            self.unleaded98Margin = unleaded98Margin
        }
        if let dieselMargin = userConfiguration["dieselMargin"] as? Float {
            self.dieselMargin = dieselMargin
        }
        if let dieselPremiumMargin = userConfiguration["dieselPremiumMargin"] as? Float {
            self.dieselPremiumMargin = dieselPremiumMargin
        }
        if let dieselHeatingMargin = userConfiguration["dieselHeatingMargin"] as? Float {
            self.dieselHeatingMargin = dieselHeatingMargin
        }
    }
    
    func toAnyObject() -> Any {
        return [
            "theme" : theme,
            "supplier" : supplier,
            "vatIncluded" : vatIncluded,
            "vatAmount" : vatAmount.round(to: 1),
            "capacity" : capacity,
            "unleaded95Margin" : unleaded95Margin.round(to: 1),
            "unleaded98Margin" : unleaded98Margin.round(to: 1),
            "dieselMargin" : dieselMargin.round(to: 1),
            "dieselPremiumMargin" : dieselPremiumMargin.round(to: 1),
            "dieselHeatingMargin" : dieselHeatingMargin.round(to: 1),
        ]
    }
    
}

