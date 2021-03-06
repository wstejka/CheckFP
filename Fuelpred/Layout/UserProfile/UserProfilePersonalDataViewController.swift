//
//  UserProfilePersonalDataViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 24/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import FirebaseStorageUI
import Floaty
import ImagePicker
import SwiftyUserDefaults


extension UserProfilePersonalDataViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

// MARK: - Extension ImagePickerDelegate
extension UserProfilePersonalDataViewController : ImagePickerDelegate {
    
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        log.verbose("")
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        log.verbose("")
        
        
        let newImageView = UIImageView()
        newImageView.image = images[0]
        guard let uid = Auth.auth().currentUser?.uid else {
            log.error("Not authenticated user.")
            return
        }
        progressBar.isHidden = false
        updateHeaderLabelFor(error: nil, successText: "savingPhoto".localized(), failText: "", cleanText: false)
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let fullPath = FirebaseStorageNode.users.rawValue + "/" + uid + "/" + FirebaseUtils.defaultUserPhotoName
        let storageRef = Storage.storage().reference().child(fullPath)
        let databaseRef = self.fbReferenceUser?.child(uid)
        newImageView.saveUser(with: storageRef, dbRef: databaseRef, progress: { (progress) in
            
            self.progressBar.setProgress(Float(progress), animated: true)
            
        }, final: { (error) in
            self.progressBar.isHidden = true
            self.updateHeaderLabelFor(error: error,
                                      successText: "photoSaved".localized(),
                                      failText: error.debugDescription)
        })
        
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        log.verbose("")
    }
    
}

class UserProfilePersonalDataViewController: UITableViewController {

    // MARK: - Variable/Constants
    // Firebase handlers
    var fbReferenceUser : DatabaseReference!
    var observerHandle : DatabaseHandle = 0
    
    let dispatchTimeDelay : Double = 1.0
    
    // MARK: - Properties

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var photoViewCell: UITableViewCell!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up placeholders for text fields
        firstNameTextField.placeholder = "firstName".localized().capitalizingFirstLetter()
        lastNameTextField.placeholder = "lastName".localized().capitalizingFirstLetter()
        phoneTextField.placeholder = "phone".localized().capitalizingFirstLetter()
        
        // Set up keyboard
        firstNameTextField.returnKeyType = .done
        firstNameTextField.delegate = self
        lastNameTextField.returnKeyType = .done
        lastNameTextField.delegate = self
        phoneTextField.returnKeyType = .done
        phoneTextField.delegate = self
        
        // userPhotoImageView
        self.userPhotoImageView.image = UIImage(named: "male_big")
        self.userPhotoImageView.layer.cornerRadius = Utils.defaultCornerRadius
        self.userPhotoImageView.layer.masksToBounds = true;
        self.userPhotoImageView.layer.borderWidth = 0;
        
        // show progress bar only for image upload event
        self.progressBar.isHidden = true
        
        // tableView settings
        self.tableView.allowsSelection = false
        self.title = "personalData".localized().capitalizingFirstLetter()
        
        // Initiate reference to firebase node
        self.fbReferenceUser = Database.database().reference(withPath: FirebaseNode.users.rawValue)
        
        // Add floaty buttons with user's photo options
        self.addFloatyButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startObserving()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        log.verbose("")
  
        if fbReferenceUser != nil {
            self.fbReferenceUser.removeAllObservers()
        }
        log.verbose("Observer for node \(FirebaseNode.users.rawValue) removed")
    }
    
    // MARK: - Methods
    
    func addFloatyButtons() {
        
        // customize change button view
        let floaty = Floaty()
        floaty.openAnimationType = .slideLeft
        floaty.addItem("placeholder".localized().capitalizingFirstLetter(), icon: UIImage(named: "cancel")!) { (item) in
            
            // Created just for providing 2nd param
            log.verbose("\"cancel\" option selected")

        }
        floaty.addItem("changePhoto".localized().capitalizingFirstLetter(), icon: UIImage(named: "image_collection")!) { (item) in
            
            log.verbose("\"change photo\" option selected")
            var configuration = Configuration()
            configuration.mainColor = .white
            
            let imagePickerController = ImagePickerController()
            imagePickerController.configuration = configuration
            imagePickerController.bottomContainer.backgroundColor = ThemesManager.get(color: .primary)
            imagePickerController.bottomContainer.doneButton.backgroundColor = ThemesManager.get(color: .primary)
            
            imagePickerController.delegate = self
            imagePickerController.imageLimit = 1
            self.present(imagePickerController, animated: true, completion: nil)
        }
        floaty.sticky = true
        self.photoViewCell.addSubview(floaty)
    }
    
    func startObserving()  {
        log.verbose("entered")
        
        // Query for user's personal data
        DispatchQueue.global().async {
            
            guard let uid = Auth.auth().currentUser?.uid else {
                log.error("This user is not authenticated.")
                return
            }
            log.verbose("uid: \(String(describing: uid))")
            
            // start observing ... 
            self.observerHandle = self.fbReferenceUser!.child(uid).observe(
                .value, with: { snapshot in

                    log.verbose("Snapshot: \(snapshot)")
                    
                    guard let fuelUser = FuelUserProfile(snapshot: snapshot) else {
                        log.error("Could not cast data properly ...")
                        return
                    }

                    self.populateFieldsWithData(from: fuelUser)
                    self.showUserPhoto(from: fuelUser)
                    Defaults[.lastUserPhotoTimestamp] = fuelUser.photoTimestamp
            })
        }
    }
    
    func populateFieldsWithData(from user : FuelUserProfile) {
        log.info("entered")

        self.firstNameTextField.text = user.firstName
        self.lastNameTextField.text = user.lastName
        self.phoneTextField.text = user.phone
        
        self.tableView.reloadData()
    }
    
    func showUserPhoto(from user: FuelUserProfile) {
        log.verbose("entered")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            log.error("Not authenticated user.")
            return
        }
        log.verbose("Photo: \"\(user.photoTimestamp)\", lastPhoto: \"\(Defaults[.lastUserPhotoTimestamp] ?? 0)\"")
        
        let photoReference = (user.photoReference.isEmpty ? FirebaseUtils.defaultUserPhotoName : user.photoReference)
        let photoReferencePath = FirebaseStorageNode.users.rawValue + "/" + uid + "/" + photoReference
        // Create a storage reference from our storage service
        let storageRef = Storage.storage().reference().child(photoReferencePath)

        var useCache = true
        if FirebaseConnectionManager.isFirebaseConnected == true &&
            user.photoTimestamp != Defaults[.lastUserPhotoTimestamp] {
            useCache = false
        }
        DispatchQueue.global().async {
            _ = self.userPhotoImageView.setImage(with: storageRef, placeholder: UIImage(named: "male_big"), useCache: useCache)
        }
    }
    
    func saveUserProfileData() {
        log.verbose("updating ...")
        
        DispatchQueue.global().async { 
            
            guard let uid = Auth.auth().currentUser?.uid else {
                log.error("Not authenticated user.")
                return
            }
            
            // Create the FuelUserData object provisioned with data provided by user
            let fuelUser = FuelUserProfile(uid: uid, firstName: self.firstNameTextField.text ?? "",
                                    lastName: self.lastNameTextField.text ?? "",
                                    phone: self.phoneTextField.text ?? "",
                                    updated: Int(Date().timeIntervalSince1970),
                                    photoReference : Defaults[.lastUserPhotoReference] ?? "",
                                    photoTimestamp : Defaults[.lastUserPhotoTimestamp] ?? 0)
            
            
            let ref = Database.database().reference(withPath: FirebaseNode.users.rawValue)
            ref.child(uid).setValue(fuelUser.toAnyObject(), withCompletionBlock: { (error, dataRef) in
                

                self.updateHeaderLabelFor(error: error,
                                     successText: "dataSaved".localized().capitalizingFirstLetter(),
                                     failText: error.debugDescription)
            })
        }
    }

    
    func updateHeaderLabelFor(error : Error?, successText : String, failText: String, cleanText: Bool = true) {
        log.info("")
        
        DispatchQueue.main.async {
            
            if error != nil {
                self.headerLabel.textColor = .red
                self.headerLabel.text = failText
            }
            else {
                self.headerLabel.textColor = ThemesManager.get(color: .secondary)
                self.headerLabel.text = successText
            }
            
        }
        if cleanText == true {
            // Clear label after 2 secs
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.dispatchTimeDelay, execute: {
                self.headerLabel.text = ""
            })
        }
    }
    
    // MARK: - Actions
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        log.info("")
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        log.info("")
        self.saveUserProfileData()
    }


}
