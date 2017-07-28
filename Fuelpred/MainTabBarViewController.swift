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


// MARK: - FirebaseUI extension
extension MainTabBarViewController: FUIAuthDelegate {
    
    /** @fn authUI:didSignInWithUser:error:
     @brief Message sent after the sign in process has completed to report the signed in user or
     error encountered.
     @param authUI The @c FUIAuth instance sending the message.
     @param user The signed in user if the sign in attempt was successful.
     @param error The error that occurred during sign in, if any.
     */
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        log.verbose("Authorization status: \(error == nil ? "Success" : "Fail")")
        if error != nil {
            //Problem signing in
            login()
        }else {
            // User is in! Here is where we code after signing in
            UserConfigurationManager.instance().refreshOnConnect()
        }
    }
    
    // MARK: - Authentication related
    func login() {
        let authUI = FUIAuth.defaultAuthUI()
        let authViewController = authUI?.authViewController()
        self.present(authViewController!, animated: true, completion: nil)
    }
    
    func checkLoggedIn() {
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
            } else {
                // No user is signed in.
                self.login()
            }
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {

        let authPicker = FUIAuthPickerViewController(authUI: authUI)
        authPicker.view.backgroundColor = ThemesManager.get(color: .primary)
        
        return authPicker
    }
}

// MARK: - Implementation
class MainTabBarViewController: UITabBarController {
    
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
        
        // ==== Use FIREBASE library to configure APIs
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
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
        checkLoggedIn()

    }
    


}