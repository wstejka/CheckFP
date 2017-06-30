//
//  UserProfileMapViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 29/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import MapKit


// MARK: - CLLocationManagerDelegate extension
extension UserProfileMapViewController : CLLocationManagerDelegate {
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        log.verbose("didChangeAuthorizationStatus: \(status)")
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            log.verbose("didUpdateLocations: \(location)")
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log.verbose("didFailWithError: \(error)")
    }
}


// MARK: - HandleMapSearchDelegate
extension UserProfileMapViewController: HandleMapSearchDelegate {
    
    func dropPinZoomIn(placemark:MKPlacemark){
        log.verbose("")
        
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension UserProfileMapViewController : MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        log.verbose("mapView viewFor annotation")
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = .orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
    
        button.setBackgroundImage(UIImage(named: "car"), for: [])
        button.addTarget(self, action: #selector(UserProfileMapViewController.getDirections), for: .touchUpInside)
        
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
    func getDirections(){
        
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}


// MARK: - UserProfileMapViewController
class UserProfileMapViewController: UIViewController {

    // MARK: - Constants/variables
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController? = nil
    var selectedPin : MKPlacemark? = nil
    
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    
    
    var userDatabaseRef : DatabaseReference? = nil
    
    // MARK: - Properties/Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchPlaceholderView: UIView!
    
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // MKMap ========
        mapView.delegate = self

        // MAPS
        configureCurrrenLocation()
        configureSearchController()
        
        userDatabaseRef = Database.database().reference(withPath: FirebaseNode.users.rawValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        log.verbose("")
        startObserving()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        log.verbose("")
        if userDatabaseRef != nil {
            userDatabaseRef?.removeAllObservers()
        }
    
    }
    
    
    // MARK: - Actions

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    func startObserving() {
        log.verbose("")
        
        // Firebase
        guard let uid = Auth.auth().currentUser?.uid else {
            log.error("This user is not authenticated.")
            return
        }
        
        _ = self.userDatabaseRef?.queryOrderedByKey().queryEqual(toValue: uid).observe(.value, with: { (snapshot) in
            log.verbose("State changed")
            
            log.verbose("Returned: users.childrenCount = \(snapshot.childrenCount)")
            
            var fuelUser = FuelUser()
            for item in snapshot.children {
                guard let currentFuelUser = FuelUser(snapshot: item as! DataSnapshot) else {
                    log.error("Could not cast data properly ...")
                    return
                }
                fuelUser = currentFuelUser
                break
            }
            
            
            
        })
        
        
    }
    
    
    func configureCurrrenLocation() {
        
        log.verbose("")
        // Location ========
        locationManager.delegate = self
        // Let's use lower accuracy to conserve battery life
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // kCLLocationAccuracyBest
        // Trigger the location permission dialog. It occurs only once
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    func configureSearchController() {
        log.verbose("")
        
        // Instantiate LocationSearchTableViewController programmatically
        guard let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as? LocationSearchTable else {
            
            log.error("Cannot instantiate LocationSearchTableViewController programmatically")
            return
        }
        // pass through mapView link to LocationSearchTable VC
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        // Instantiate UISearchController with LocationSearchTableViewController object
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        // Set up locationSearchTable as a delegate
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        // Configure seach bar and embed it in navigationbar
        let searchBar = resultSearchController!.searchBar
        
        //        navigationItem.titleView = resultSearchController?.searchBar
        searchPlaceholderView.addSubview(searchBar)
        searchBar.sizeToFit()
        searchBar.placeholder = "homeLocation".localized().capitalizingFirstLetter()
        
        // Configure the UISearchController appearance
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        // limits the overlap area to just the View Controller’s frame instead of the whole Navigation Controller.
        definesPresentationContext = true

    }
    


}
