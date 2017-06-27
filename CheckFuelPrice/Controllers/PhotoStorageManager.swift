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
    
    private static var managerInstance: PhotoStorageManager = {
        log.verbose("entered")
        // Here ThemesManager is instantatied
        let startTime = Date().timeIntervalSinceNow
        let thisInstance = PhotoStorageManager()
        log.verbose("PhotoStorageManager instantiated in \((Date().timeIntervalSinceNow - startTime)) secs.")
        
        return thisInstance
    }()
    
    static func instance() -> PhotoStorageManager {
        log.verbose("entered")
        
        return PhotoStorageManager.managerInstance
    }
    
    
    
    
    // MARK: - Struct object constructor
    
    private init() {}
    
    
    //! This method does two things: update user photo in storage and update user's profile with name
    public func saveUser(photo : UIImage, with name: String = "")  {
        
        
        DispatchQueue.global().async {
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
            let uploadTask = storageRef.putData(data, metadata: metadata)
            
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
            }
            
            uploadTask.observe(.success) { snapshot in
                // Upload completed successfully. Let's make an update in
                log.verbose("success")
            }
            
            uploadTask.observe(.failure) { snapshot in
                
                log.verbose("failure")
                if let error = snapshot.error as? NSError {
                    switch (StorageErrorCode(rawValue: error.code)!) {
                    case .objectNotFound:
                        // File doesn't exist
                        break
                    case .unauthorized:
                        // User doesn't have permission to access file
                        break
                    case .cancelled:
                        // User canceled the upload
                        break
                    case .unknown:
                        // Unknown error occurred, inspect the server response
                        break
                    default:
                        // A separate error occurred. This is a good place to retry the upload.
                        break
                    }
                }
            }
        }

    }
    
}

