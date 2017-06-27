//
//  PhotoStorageManager.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 27/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

//! PhotoStorageManager instance keeps in-sync user's profile photo on Firebase Storage 
//  and reference/timestamp info in Firebase DB
class PhotoStorageManager {
    
    // MARK: Constants/Variable
    
    // MARK: Singleton lifecycle
    
    init() {}
    
    
    // MARK: - Struct object constructor
    
    
    //! This method does two things: update user photo in storage and update user's profile with name
    func saveUser(photo : UIImage, with name: String = "", progress : @escaping (Double) -> Void,
                  success: @escaping (NSError?) -> Void)  {
        
        
        DispatchQueue.global().async {
            
            // is connected?
            if FirebaseConnectionManager.isFirebaseConnected == false {
                // TODO: Present pop-up with note
                log.error("Cannot update photo as device is not connected")
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {
                log.error("Not authenticated user.")
                return
            }
            
            // Data in memory
            guard let data = UIImageJPEGRepresentation(photo, FirebaseStorageFileCompressionLevel.veryhigh.rawValue) else {
                log.error("Cannot convert UIImage to JPEG with compression")
                return
            }
            
            var imageName = name
            // Create a reference to the file you want to upload
            if imageName.isEmpty {
                imageName = FirebaseUtils.defaultPhotoUserName
            }

            // Create the file metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let fullLocationRef = FirebaseStorageNode.users.rawValue + "/" + uid + "/" + imageName
            let storageRef = Storage.storage().reference().child(fullLocationRef)
            // Upload the file to the path "users/uid/photo.jpg"
            let uploadTask : StorageUploadTask = storageRef.putData(data, metadata: metadata)
            
            // Listen for state changes, errors, and completion of the upload.
            uploadTask.observe(.resume) { snapshot in
                // Upload resumed, also fires when the upload starts
                log.verbose("resume")
            }
            
            uploadTask.observe(.pause) { snapshot in
                // Upload paused
                log.verbose("pause")
            }
            
            uploadTask.observe(.progress) { snapshot in
                // Upload reported progress
                let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                log.verbose("percent: \(percentComplete)")
                progress(percentComplete)
                
            }
            
            uploadTask.observe(.success) { snapshot in
                log.verbose("success")

                // Upload completed successfully. Let's make an update in DB
                success(nil)
                
            }
            
            uploadTask.observe(.failure) { snapshot in
                
                if let error = snapshot.error as NSError? {
                    
                    if let errorCode = StorageErrorCode(rawValue: error.code) {
                        log.verbose("failure with code: \(errorCode)")
                    }
                    success(error)
                }
            }
        }
    }
}

