//
//  ThemesManager.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 20/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

struct ThemesManager {
    
    // MARK: Variables/constants
    enum Color {
        case primary
        case secondary
        case color1     // blue
        case color2     // yellow
        case color3     // orange
    }
    
    enum Theme : Int {
        case basic
        case theme1
        case theme2
        
        init?(withName: String?) {

            guard let name = withName else {
                return nil
            }
            for item in iterateEnum(Theme.self) {
                
                if String(describing: item) == name {
                    self = item
                    return
                }
            }
            return nil
        }
    }
    
    static var activeTheme : Theme = .basic
    // computed variable {get}
    static var themes: [ThemesManager.Color : UIColor] {
    
        if ThemesManager.activeTheme == .basic {
            
            return [.primary    : .blueCustomColor,
                    .secondary  : .aquaCrayonColor,
                    .color1     : .dodgerBlueHTMLColor,
                    .color2     : .cantalopeCrayonColor,
                    .color3     : .tangerineCrayonColor]
        }
        return [:]
    }
    
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
    
    static func get(color: ThemesManager.Color) -> UIColor {
        
        guard let theColor = ThemesManager.themes[color] else {
            return .blueCustomColor
        }
        return theColor
    }
}


/*
 // List of colors:
 [.aquaCrayonColor, .cantalopeCrayonColor, .iceCrayonColor, .midnightCrayonColor, .oceanCrayonColor, .skyCrayonColor, .tangerineCrayonColor, .aquaHTMLColor, .burlyWoodHTMLColor, .cornflowerBlueHTMLColor, .darkBlueHTMLColor, .goldHTMLColor, .goldenRodHTMLColor, .darkGoldenRodHTMLColor, .darkorangeHTMLColor, .deepSkyBlueHTMLColor, .dodgerBlueHTMLColor, .fireBrickHTMLColor, .indigoHTMLColor, .lightBlueHTMLColor, .lightCyanHTMLColor, .lightSalmonHTMLColor, .lightSkyBlueHTMLColor, .lightSteelBlueHTMLColor, .mediumVioletRedHTMLColor, .moccasinHTMLColor, .navajoWhiteHTMLColor, .navyHTMLColor, .orangeHTMLColor, .orangeRedHTMLColor, .papayaWhipHTMLColor, .peachPuffHTMLColor, .peruHTMLColor, .purpleHTMLColor, .royalBlueHTMLColor, .salmonHTMLColor, .sandyBrownHTMLColor, .skyBlueHTMLColor, .steelBlueHTMLColor, .yellowGreenHTMLColor]
 */
