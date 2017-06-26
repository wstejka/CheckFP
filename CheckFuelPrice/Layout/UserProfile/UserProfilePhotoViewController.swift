//
//  UserProfilePhotoViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 26/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import FirebaseStorageUI

class UserProfilePhotoViewController: UIViewController {

    // MARK: - constants/variables
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    
    // MARK: - properties
    var storageRef : StorageReference?
    
    // MARK: UIView lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let uid = Auth.auth().currentUser?.uid else {
            log.error("This user is not authenticated.")
            return
        }
        
        let photReferenceName = FirebaseStorageNode.users.rawValue + "/" + uid + "/photo.jpg"
        log.verbose("downloading personal photo from: \(photReferenceName)) for user \(uid)")

        // Create a storage reference from our storage service
        self.storageRef = Storage.storage().reference().child(photReferenceName)
        self.userPhotoImageView.sd_addActivityIndicator()
        let cache = SDImageCache()
        cache.config.shouldCacheImagesInMemory = false
        self.userPhotoImageView.sd_setImage(with: storageRef!, maxImageSize: 0, placeholderImage: UIImage(named: "male2"), cache: cache,  completion: { (image, error, cache, refrence) in
        
            self.userPhotoImageView.sd_removeActivityIndicator()
            if error != nil {
                log.error("Photo download failed")
            }
            else {
                log.verbose("Photo downloaded end")
            }
            
        })
        
    }
    
    deinit {
        log.verbose("")
    }
    
    // MARK: - Actions

    // MARK: - Methods

}
