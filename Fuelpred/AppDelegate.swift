//
//  AppDelegate.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 14/04/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import SwiftyBeaver
import Charts
import Chameleon
import Fabric
import Crashlytics
import TwitterKit
import Firebase
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI
import Keys
import Floaty
import SwiftyUserDefaults

// MARK: public constants
let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // ============== Set up SwiftyBeaver  =================== //
        // add log destinations. at least one is needed!
        let console = ConsoleDestination()  // log to Xcode Console
        // use custom format and set console output to short time, log level & message
        console.format = "$Dyyyy-MM-dd HH:mm:ss$d $L [$N:$l $F] $M"
        // add the destinations to SwiftyBeaver
        log.addDestination(console)
        // ======================================================= //
        
        log.verbose("Enter")
        
        // That's the workaround to not engage whole functionallity (especially UI part) in UT activities
        // Return if this is a unit test
        if let _ = NSClassFromString("XCTest") {
            log.verbose("========== UNIT TESTING ==============")
            return true
        }
    
        // === Configure Crashlythics =====/
        Fabric.with([Crashlytics.self])
        
        // === Configure Theme ==== //
//        Chameleon.setGlobalThemeUsingPrimaryColor(ThemesManager.get(color: .primary), withSecondaryColor: nil,
//                                                  andContentStyle: UIContentStyle.light)
        // cutomize general view
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.barTintColor = ThemesManager.get(color: .primary)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // === Configure Firebase ==== //
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true

        // Run FirebaseConnectionManager which keeps the firebase connection status
        _ = FirebaseConnectionManager.instance()
        // By default set authentication status as false; It will be set up in next step
        Defaults[.isAuthenticated] = false
        
        // ====== Set up authentication stuff at the startup so that it can be used later in app
        // ==== Use FirebaseUI library to configure APIs
        let authUI = FUIAuth.defaultAuthUI()
        
        // === Set up Twitter consumer's key and secret
        let key = CheckFPKeys()
        Twitter.sharedInstance().start(withConsumerKey:key.twitterConsumerKey, consumerSecret:key.twitterConsumerSecret)
        
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIFacebookAuth(),
            FUITwitterAuth(),
            //            FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
        ]
        
        authUI?.providers = providers
        
        // Run UserConfigurationManager which keeps up-to-date the user's configuration
        _ = UserConfigurationManager.instance()
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //
    var orientationLock = UIInterfaceOrientationMask.all
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }

    // MARK: - Authentication/FirebaseAuthUI
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }

}

