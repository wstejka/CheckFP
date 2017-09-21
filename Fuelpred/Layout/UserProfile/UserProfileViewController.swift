//
//  UserProfileViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 19/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Firebase
import FirebaseAuth
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI
import TwitterKit
import Keys

// MARK: - UITableViewDataSource extension
extension UserProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ((Defaults[.isAuthenticated] == true) ? profileOptionsArray.count : unauthenticatedProfileOptionsArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var optionsArray = unauthenticatedProfileOptionsArray
        if Defaults[.isAuthenticated] == true {
            optionsArray = profileOptionsArray
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        guard let profileOption = ProfileOption(rawValue: indexPath.row),
            let descriptionNode = optionsArray[profileOption],
            let descriptionText = descriptionNode[ProfileOptionProperty.name] as? String,
            let imageName = descriptionNode[ProfileOptionProperty.photo] as? String,
            let color = descriptionNode[ProfileOptionProperty.color] as? ThemesManager.Color else {
                log.error("")
                return cell
        }
        
        // Let's add objects to UIView programmatically !!
        // Remark: Much more efficient and easy way is to use the storyboard and it's features ...
        //         The reason I'm doing it here is to present that it's possible and how to do it
        // ======= Button ======= //
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50.0, height: 30.0))
        cell.addSubview(button)
        
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        // button's constraints
        button.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 30).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, constant: 0).isActive = true
        button.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 0.8).isActive = true
        
        let tintedImage = UIImage(named: imageName )?.tinted()
        button.tintColor = ThemesManager.get(color: color)
        button.setImage(tintedImage, for: .normal)
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.topAnchor.constraint(equalTo: button.topAnchor, constant: 0).isActive = true

        
        // ======= Label ======== //
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: 30.0))
        cell.contentView.addSubview(label)
        label.font = UIFont(name: label.font.fontName, size: 14)

        label.text = descriptionText.localized().capitalized
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 30).isActive = true
        label.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true

        return cell
    }

    @objc func buttonAction(sender: UIButton!) {
        log.verbose("Button tapped: \(sender.description)")
    }
}

// MARK: - UITableViewDelegate extension
extension UserProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        return 70.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        log.verbose("didSelectRowAtIndex: \(indexPath.row)")
        
        if Defaults[.isAuthenticated] == true {
                
            if indexPath.row == ProfileOption.personalData.rawValue {
                self.processPersonalData()
            }
            if indexPath.row == ProfileOption.coordinates.rawValue {
                self.processCoordinates()
            }
            else if indexPath.row == ProfileOption.singOut.rawValue {
                self.processSignOut()
            }
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        else {
            if indexPath.row == ProfileOption.personalData.rawValue {
                self.processSignIn()
            }
        }
    }
    
}

// MARK: - FUIAuthDelegate extension
extension UserProfileViewController : FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        
        log.verbose("Authorization status: \(error == nil ? "Success" : "Fail")")
        if error == nil {
            // User is signed in.
            Defaults[.isAuthenticated] = true
            // User is in! Here is where we code after signing in
            UserConfigurationManager.instance().refreshOnConnect()
            // refresh table
            self.tableView.reloadData()
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        log.verbose("")
        let authPicker = FUIAuthPickerViewController(authUI: authUI)
        authPicker.view.backgroundColor = ThemesManager.get(color: .primary)
        
        return authPicker
    }
    
    // MARK: - Authentication related
    func login() {
        log.verbose("")
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        let authViewController = authUI?.authViewController()
        self.present(authViewController!, animated: true, completion: nil)
    }
    
}

class UserProfileViewController: UIViewController {

    // MARK: Constants/Variable
    let profileOptionsArray : [ProfileOption : [ProfileOptionProperty : Any]] =
        [.personalData : [.name : "personalData", .photo : "businessCard", .color : ThemesManager.Color.primary],
//         .photo : [.name : "photo", .photo : "camera", .color : ThemesManager.Colors.orange],
         .coordinates : [.name : "coordinates", .photo : "location", .color : ThemesManager.Color.color2],
         .singOut : [.name : "singOut", .photo : "logout", .color : ThemesManager.Color.color3]]

    let unauthenticatedProfileOptionsArray : [ProfileOption : [ProfileOptionProperty : Any]] =
        [.personalData : [.name : "signIn", .photo : "login", .color : ThemesManager.Color.color3]]

    
    enum ProfileOption : Int {
        case personalData
        case coordinates
        case singOut
        case signIn
    }
    
    enum ProfileOptionProperty : Int {
        case name
        case photo
        case color
    }
    
    let signOutSegueName = "unwindToFuelInfoAndSingOutWithSender"
    let personalDataSegueName = "userProfilePersonalDataSegue"

    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    var stateDidChangeListenerHandle : AuthStateDidChangeListenerHandle? = nil
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    deinit {
        log.info("")
    }

    // MARK: - Actions
    
    // MARK: - Methods

    func processPersonalData() {
        log.verbose("entered")

        guard let navigationViewController = storyboard?.instantiateViewController(withIdentifier: "UserProfilePersonalDataNavigationController") else {
            log.error("Could not instantiate \"UserProfilePersonalDataNavigationController\" object")
            return
        }
        navigationViewController.modalTransitionStyle = .coverVertical
        present(navigationViewController, animated: true, completion: nil)
        
    }
    
    func processCoordinates() {
        log.verbose("entered")
        
        guard let navigationViewController = storyboard?.instantiateViewController(withIdentifier: "UserProfileMapNavigationController") else {
            log.error("Could not instantiate \"UserProfileMapNavigationController\" object")
            return
        }
        navigationViewController.modalTransitionStyle = .coverVertical
        present(navigationViewController, animated: true, completion: nil)
        
    }
    
    func processSignOut() {
        log.verbose("entered")
        let title = "doyouwanttosignout".localized().capitalizingFirstLetter() + " ?"
        let alertController = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        let signoutAction = UIAlertAction(title : "answerYes".localized().capitalizingFirstLetter(), style : UIAlertActionStyle.default){
            (action) in
            log.verbose("Yes")
//            self.performSegue(withIdentifier: self.signOutSegueName, sender: nil)
            // Sign out
            try! Auth.auth().signOut()
            Defaults[.isAuthenticated] = false
            // refresh table
            self.tableView.reloadData()
        }
        let ignoreAction = UIAlertAction(title: "answerNo".localized().capitalizingFirstLetter(),
                                         style: UIAlertActionStyle.default, handler: { action in
                                            log.verbose("No")
        })
        
        alertController.addAction(ignoreAction)
        alertController.addAction(signoutAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func processSignIn() {
        log.verbose("entered")
        login()
    }
    
}
