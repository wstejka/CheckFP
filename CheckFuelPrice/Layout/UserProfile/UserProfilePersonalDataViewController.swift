//
//  UserProfilePersonalDataViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 24/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class UserProfilePersonalDataViewController: UITableViewController {

    // MARK: Variable/Constants
    var refUserItems : DatabaseReference? = nil
    var observerHandle : DatabaseHandle = 0
    
    
    // MARK: Properties

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    
    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startObserving()
        
        // set up placeholders for text fields
        self.firstNameTextField.placeholder = "firstName".localized().capitalizingFirstLetter()
        self.lastNameTextField.placeholder = "lastName".localized().capitalizingFirstLetter()
        self.phoneTextField.placeholder = "phone".localized().capitalizingFirstLetter()

        
        // tableView settings
        self.tableView.allowsSelection = false
        self.title = "personalData".localized().capitalizingFirstLetter()

    }
        
    deinit {
        log.verbose("")
        if (self.refUserItems != nil) && (self.observerHandle > 0) {
            // remove observer
            self.refUserItems!.removeObserver(withHandle: self.observerHandle)
            log.verbose("Observer for node \(FirebaseNode.users.rawValue) removed")
            

        }
    }
    
    // MARK: Methods
    
    func startObserving()  {
        log.verbose("entered")
        // Query for user's data
        DispatchQueue.global().async {
            // create observer
            guard let uid = Auth.auth().currentUser?.uid else {
                log.error("This user is not authenticated.")
                return
            }
            log.verbose("uid: \(String(describing: uid))")

            // create reference to user node
            self.refUserItems = Database.database().reference(withPath: FirebaseNode.users.rawValue)
            self.observerHandle = self.refUserItems!.queryOrderedByKey().queryEqual(toValue: uid).observe(
                .value, with: { [weak self] snapshot in
                    
                    guard let selfweak = self else {
                        log.error("Could not get weak self")
                        return
                    }
                    
                    log.verbose("Returned: users.childrenCount = \(snapshot.childrenCount)")
                    
                    var fuelUser : FuelUser? = nil
                    for item in snapshot.children {
                        fuelUser = FuelUser(snapshot: item as! DataSnapshot)
                    }
                    
                    if fuelUser == nil {
                        log.warning("There is no yet profile for user: \(uid). Let's create placeholder")
                        // There is no yet user's profile. Let's create placeholder
                        fuelUser = FuelUser(uid: uid, firstName: "", lastName: "", phone: "", updated: 0)
                    }
                    selfweak.createUserParams(from: fuelUser)
            })
        }
    }
    
    func createUserParams(from user : FuelUser?) {
        log.info("entered")

        guard let user = user else { return }
        self.firstNameTextField.text = user.firstName
        self.lastNameTextField.text = user.lastName
        self.phoneTextField.text = user.phone
        
        self.tableView.reloadData()
    }
    
    func updateUserProfileData() {
        log.verbose("updating ...")
        
        DispatchQueue.global().async {
            
            guard let uid = Auth.auth().currentUser?.uid else {
                log.error("Not authenticated user.")
                return
            }
            // Create the FuelUserData object provisioned with data provided by user
            let fuelUser = FuelUser(uid: uid, firstName: self.firstNameTextField.text ?? "",
                                    lastName: self.lastNameTextField.text ?? "",
                                    phone: self.phoneTextField.text ?? "", updated: Int(Date().timeIntervalSince1970))
            
            
            let ref = Database.database().reference(withPath: FirebaseNode.users.rawValue)
            ref.child(uid).setValue(fuelUser.toAnyObject(), withCompletionBlock: { (error, dataRef) in
                
                
                log.verbose("XXX")
                DispatchQueue.main.async {
                    if error != nil {
                        self.headerLabel.textColor = .red
                        self.headerLabel.text = error.debugDescription
                    }
                    else {
                        self.headerLabel.textColor = ThemesManager.instance().get(color: ThemesManager.Colors.lightBlue)
                        self.headerLabel.text = "dataSaved".localized().capitalizingFirstLetter()
                    }
                    
                    // Clear label after 2 secs
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                        self.headerLabel.text = ""
                    })
                }
            })
        
        }
    }
    
    // MARK: Actions
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.updateUserProfileData()
    }

    
}
