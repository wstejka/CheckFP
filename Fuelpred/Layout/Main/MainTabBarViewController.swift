//
//  MainTabBarViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 02/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI
import TwitterKit
import Keys
import SwiftyUserDefaults


// MARK: - Implementation
class MainTabBarViewController: UITabBarController {
    
    
    // MARK: - Vars/Consts
    var stateDidChangeListenerHandle : AuthStateDidChangeListenerHandle? = nil
    
    // MARK: - UIView lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mainTabNamesList : [String?] = ["mainTab1Name", "mainTab2Name"]
        
        // Let's name the tabs depend on the language
        var counter = 0
        for viewController in self.viewControllers! {

            // Ensure index is not out of range
            if counter >= mainTabNamesList.count {
                log.error("Index out of range. Add missing values or remove view controler")
                break
            }
            let tabName = mainTabNamesList[counter]?.localized(withDefaultValue: "")
            viewController.tabBarItem?.title = tabName
            // increment counter
            counter += 1
        }
        
        checkLoggedIn()
    }
    
    func checkLoggedIn() {
        
        stateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                Defaults[.isAuthenticated] = true
                // User is in! Here is where we code after signing in
                UserConfigurationManager.instance().refreshOnConnect()
            }
            log.verbose("Authenication status=\(Defaults[.isAuthenticated] ?? false)")
            // This is first place accessed in app and we put it here just for one reason: to determine user is authenticated or not
            // Let's deregister from this event after receiving information
            Auth.auth().removeStateDidChangeListener(self.stateDidChangeListenerHandle!)
            log.verbose("Deregister from FIRAuthStateDidChangeListenerHandle event")
        }
    }
}
