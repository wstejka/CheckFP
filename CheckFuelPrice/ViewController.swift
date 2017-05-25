//
//  ViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 14/04/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    // MARK: - constants
    let customTableViewCellName = "FuelTableViewCellId"
    
    // MARK: - properties
    
    @IBOutlet weak var fuelTableView: UITableView!
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.fuelTableView.dataSource = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableView Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let customViewCell = self.fuelTableView.dequeueReusableCell(withIdentifier: self.customTableViewCellName) as? FuelTableViewCell else {
            return UITableViewCell()
        }
        
        return customViewCell
    }


    // MARK: - Actions
}

