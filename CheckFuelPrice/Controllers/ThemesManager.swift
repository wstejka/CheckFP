//
//  ThemesManager.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 20/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

struct ThemesManager {
    
    // MARK: Variables/constants
    enum Colors : Int {
        case blue
        case blue_v2
        case lightBlue
        case lightBlue_v2
        case yellow
        case orange
    }
    
    lazy var themes: [ThemesManager.Colors : UIColor] = {
    
            return [.blue : .aquaCrayonColor,
                    .lightBlue : .dodgerBlueHTMLColor,
                    .lightBlue_v2 : .blueCustomColor,
                    .yellow : .cantalopeCrayonColor,
                    .orange : .tangerineCrayonColor]
    }()
    
    enum FuelColor : Int {
        case unleaded95
    }

    lazy var fuelPriceColors: [ThemesManager.Colors : UIColor] = {
        
        return [.blue : .aquaCrayonColor,
                .lightBlue : .dodgerBlueHTMLColor,
                .yellow : .cantalopeCrayonColor,
                .orange : .tangerineCrayonColor]
    }()

    
    // MARK: Singleton lifecycle
    
    private static var themesManagerInstance: ThemesManager = {
        log.verbose("entered")
        // Here ThemesManager is instantatied 
        let startTime = Date().timeIntervalSinceNow
        let thisInstance = ThemesManager()
        log.verbose("ThemesManager instantiated in \((Date().timeIntervalSinceNow - startTime)) secs.")
        
        return thisInstance
    }()

    static func instance() -> ThemesManager {
        log.verbose("entered")
    
        return ThemesManager.themesManagerInstance
    }
    
    // MARK: - Struct object constructor
    private init() {
    }
    
    // MARK: - Methods
    
    func get(color: ThemesManager.Colors) -> UIColor {
        
        guard let theColor = ThemesManager.themesManagerInstance.themes[color] else {
            return UIColor.black
        }
        return theColor
    }
    
}


/*
 // List of colors:
 [.aquaCrayonColor, .cantalopeCrayonColor, .iceCrayonColor, .midnightCrayonColor, .oceanCrayonColor, .skyCrayonColor, .tangerineCrayonColor, .aquaHTMLColor, .burlyWoodHTMLColor, .cornflowerBlueHTMLColor, .darkBlueHTMLColor, .goldHTMLColor, .goldenRodHTMLColor, .darkGoldenRodHTMLColor, .darkorangeHTMLColor, .deepSkyBlueHTMLColor, .dodgerBlueHTMLColor, .fireBrickHTMLColor, .indigoHTMLColor, .lightBlueHTMLColor, .lightCyanHTMLColor, .lightSalmonHTMLColor, .lightSkyBlueHTMLColor, .lightSteelBlueHTMLColor, .mediumVioletRedHTMLColor, .moccasinHTMLColor, .navajoWhiteHTMLColor, .navyHTMLColor, .orangeHTMLColor, .orangeRedHTMLColor, .papayaWhipHTMLColor, .peachPuffHTMLColor, .peruHTMLColor, .purpleHTMLColor, .royalBlueHTMLColor, .salmonHTMLColor, .sandyBrownHTMLColor, .skyBlueHTMLColor, .steelBlueHTMLColor, .yellowGreenHTMLColor]
 */
