//
//  UserProfileMapViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 29/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import MapKit

class UserProfileMapViewController: UIViewController {

    // MARK: - Constants/variables
    
    
    // MARK: - Properties/Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
  
    
    
    // MARK: - Actions

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods



}
