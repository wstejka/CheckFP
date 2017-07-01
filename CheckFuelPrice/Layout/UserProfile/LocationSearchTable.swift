//
//  LocationSearchTableViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 29/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import MapKit


// MARK: - protocol HandleMapSearchDelegate
protocol HandleMapSearchDelegate {
    
    func dropPinZoomIn(placemark:MKPlacemark)
}

// MARK: - extension HandleMapSearchDelegate
extension LocationSearchTable : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        log.verbose("updateSearchResults")
        
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        
        request.naturalLanguageQuery = searchBarText
        request.region = MKCoordinateRegion(center: mapView.region.center, span: MKCoordinateSpanMake(1000, 1000)) //mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

// MARK: - extension UITableViewDelegate
extension LocationSearchTable {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let alertController = UIAlertController(title: "homeLocationQuestion".localized().capitalizingFirstLetter(),
                                                message: "", preferredStyle: UIAlertControllerStyle.alert)
        let alertActionYes = UIAlertAction(title: "answerYes".localized().capitalizingFirstLetter(), style: UIAlertActionStyle.default) { (action) in

            // Firebase
            guard let uid = Auth.auth().currentUser?.uid else {
                log.error("This user is not authenticated.")
                return
            }
            let selectedItem = self.matchingItems[indexPath.row].placemark
            let userLocation = FuelUserLocation(latitude: selectedItem.coordinate.latitude ,
                                                longitude: selectedItem.coordinate.longitude,
                                                name: selectedItem.name ?? "", city: selectedItem.locality ?? "",
                                                state: selectedItem.administrativeArea ?? "")
            self.userDatabaseRef?.child(uid).setValue(userLocation.toAnyObject())
            self.dismiss(animated: true, completion: nil)
            
        }
        let alertActionNo = UIAlertAction(title: "answerNo".localized().capitalizingFirstLetter(),
                                           style: UIAlertActionStyle.default) { (action) in
                                            
        }
        alertController.addAction(alertActionYes)
        alertController.addAction(alertActionNo)
        present(alertController, animated: true, completion: nil)
        
    }
}

// MARK: - TableViewDataSource delegate methods
extension LocationSearchTable {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        
        return cell
    }

}

// MARK: - LocationSearchTable
class LocationSearchTable : UITableViewController {
    
    // MARK: - Variables
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate : HandleMapSearchDelegate? = nil
 
    var userDatabaseRef : DatabaseReference? = nil
    
    
    // MARK: UITableViewController lifecycle
    
    override func viewDidLoad() {
        log.verbose("")
        userDatabaseRef = Database.database().reference(withPath: FirebaseNode.userlocation.rawValue)
        
    }
    
    // MARK: - Methods
    
    func parseAddress(selectedItem : MKPlacemark) -> String {

        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
}
