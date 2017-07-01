//
//  UIImageView+Extension.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 01/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//
//
import SDWebImage
import FirebaseStorageUI
import ObjectiveC

//  This is a FirebaseUI implementation originaly writen in objc and converted to Swift with soem small mods
//  https://github.com/firebase/FirebaseUI-iOS/blob/master/FirebaseStorageUI/UIImageView%2BFirebaseStorage.m
//  implementation in some aspects like using SDWebImage as a backend for storing files

private var downloadTaskObjectKey: UInt8 = 0
private var uploadTaskObjectKey: UInt8 = 0

private var uploadTaskInProgressKey: UInt8 = 0

public extension UIImageView {
    
    // MARK: - Variables, pseudo-stored variables
    
    var downloadTaskObject: StorageDownloadTask? {
        get {
            return objc_getAssociatedObject(self, &downloadTaskObjectKey) as? StorageDownloadTask
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &downloadTaskObjectKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var uploadTaskObject: StorageUploadTask? {
        get {
            return objc_getAssociatedObject(self, &uploadTaskObjectKey) as? StorageUploadTask
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &uploadTaskObjectKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var uploadInProgress: Bool {
        get {
            guard let inProgress = objc_getAssociatedObject(self, &uploadTaskInProgressKey) as? Bool else {
                return false
            }
            return inProgress
        }
        
        set(newValue) {
            objc_setAssociatedObject(self, &uploadTaskInProgressKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    // MARK: - UIImageView Methods
    
    func setImage(with ref: StorageReference?, placeholder: UIImage?, useCache: Bool = true) -> StorageDownloadTask? {
        
        // STEP 1: First of all validate data ===============
        
        guard let storageRef = ref else {
            log.error("Empty storage reference")
            return nil
        }
        log.verbose("photo: \(storageRef.fullPath)")
        
        // If there's already a download on this UIImageView, cancel it
        if (self.downloadTaskObject != nil) {
            self.downloadTaskObject?.cancel()
            self.downloadTaskObject = nil
        }
        
        let cache = SDImageCache()
        // Query cache for image before trying to download
        if useCache == true {
            let key = storageRef.fullPath
            var cached : UIImage?
            
            cached = cache.imageFromCache(forKey: key)
            if cached != nil {
                log.verbose("Picking up photo from cache")
                DispatchQueue.main.async {
                    self.image = cached
                }
                return nil
            }
        }
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let download = storageRef.getData(maxSize: FirebaseUtils.fileSizeLimit) { (data, error) in
            
            
            if data == nil {
                log.error("File download failed with error: \(error.debugDescription)")
                // Set placeholder image
                self.image = placeholder
                return
            }
            log.verbose("Picking up photo from firebase storage")
            let image = UIImage(data: data!)
            DispatchQueue.main.async {
                self.image = image
            }
            log.verbose("Updating cache with photo")
            cache.store(image, forKey: storageRef.fullPath, completion: nil)
        }
        
        self.downloadTaskObject = download
        return self.downloadTaskObject
    }
    
    
    
    func saveUser(with ref: StorageReference?, dbRef: DatabaseReference?,
                  progress : @escaping (Double) -> Void, final : @escaping (NSError?) -> Void) {
        
        log.verbose("entered")
        
        // STEP 1: First of all validate data ===============
        // is connected?
        if FirebaseConnectionManager.isFirebaseConnected == false {
            // TODO: Present pop-up with note
            log.error("Cannot update photo as device is not connected")
            final(NSError(domain: "", code: 1, userInfo: ["error" : "Cannot update photo as device is not connected"]))
            return
        }
        
        guard let storageRef = ref else {
            log.error("Empty storage reference")
            final(NSError(domain: "", code: 2, userInfo: ["error" : "Empty storage reference"]))
            return
        }
        guard let databaseRef = dbRef else {
            log.error("Empty database reference")
            final(NSError(domain: "", code: 3, userInfo: ["error" : "database"]))
            return
        }
        
        // Data in memory
        guard let image = self.image else {
            log.error("No image in UIImageView")
            final(NSError(domain: "", code: 4, userInfo: ["error" : "No image in UIImageView"]))
            return
        }
        
        guard let data = UIImageJPEGRepresentation(image, FirebaseStorageFileCompressionLevel.veryhigh.rawValue) else {
            log.error("Cannot convert UIImage to JPEG with compression")
            final(NSError(domain: "", code: 5, userInfo: ["error" : "Cannot convert UIImage to JPEG with compression"]))
            return
        }
        
        // STEP 2: stop upload and download if there is any ===============
        // If there's already a download on this UIImageView, cancel it
        if (self.downloadTaskObject != nil) {
            self.downloadTaskObject?.cancel()
            self.downloadTaskObject = nil
        }
        // If there's already a upload on this UIImageView, cancel it
        if (self.uploadTaskObject != nil) {
            self.uploadTaskObject?.cancel()
            self.uploadTaskObject = nil
        }
        
        // STEP 3 ===============
        // Get reference to the file you want to upload
        let key = storageRef.fullPath
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        log.verbose("uploading: \(key) file to the storage")
        
        // Upload the file to the path "users/uid/photo.jpg"
        self.uploadTaskObject = storageRef.putData(data, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        self.uploadTaskObject!.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
            log.verbose("resume")
        }
        
        self.uploadTaskObject?.observe(.pause) { snapshot in
            // Upload paused
            log.verbose("pause")
        }
        
        self.uploadTaskObject?.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            log.verbose("percent: \(percentComplete)")
            progress(percentComplete)
            
        }
        
        self.uploadTaskObject?.observe(.success) { snapshot in
            log.verbose("success")
            
            // Upload completed successfully. Update cache with new photo
            let cache = SDImageCache()
            log.verbose("updating cache with uploaded image")
            cache.store(image, forKey: storageRef.fullPath, completion: {
                
                //Let's get update DB
                
                log.verbose("updating timestamp for \(databaseRef)")
                let timestamp = Int(Date().timeIntervalSince1970)
                databaseRef.updateChildValues([FirebaseNode.photoTimestamp.rawValue : timestamp,
                                               FirebaseNode.photoReference.rawValue : FirebaseUtils.defaultUserPhotoName], withCompletionBlock: { (error, ref : DatabaseReference) in
                                                
                                                if error == nil {
                                                    log.verbose("timestamp updated")
                                                    final(nil)
                                                }
                                                else {
                                                    log.verbose("timestamp update failed")
                                                    final(NSError(domain: "", code: 6, userInfo: ["error" : "timestamp update failed"]))
                                                }
                })
            })
        }
        
        self.uploadTaskObject?.observe(.failure) { snapshot in
            
            if let error = snapshot.error as NSError? {
                
                if let errorCode = StorageErrorCode(rawValue: error.code) {
                    log.verbose("failed with code: \(errorCode)")
                }
                final(error)
            }
        }
    }
}

