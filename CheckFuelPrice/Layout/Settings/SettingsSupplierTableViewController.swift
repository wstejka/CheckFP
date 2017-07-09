//
//  SettingsSupplierTableViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 09/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

protocol SupplierChangedDelegate {
    
    func selected(supplier: Producer)
}

// MARK: - Extension - Table view data source
extension SettingsSupplierTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "supplierCell", for: indexPath)
        
        // Configure the cell...
        let supplier = items[indexPath.row]
        let supplierName = String(describing: supplier)
        cell.textLabel?.text = supplierName.capitalizingFirstLetter()
        
        if supplier == currentSupplier {
            cell.textLabel?.textColor = ThemesManager.get(color: .primary)
        }
        
        return cell
    }
    
}

// MARK: - Extension - Table view delegate
extension SettingsSupplierTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        log.verbose("didSelectRowAt")
        
        let supplier = items[indexPath.row]
        delegate?.selected(supplier: supplier)
        _ = navigationController?.popViewController(animated: true)
        
    }
    
}

class SettingsSupplierTableViewController: UITableViewController {
    
    // MARK: Vars/Consts
    var items : [Producer] {
        
        get {
            var options : [Producer] = []
            for item in iterateEnum(Producer.self) {
                
                // ignore none option
                if item == Producer.none {
                    continue
                }
                
                options.append(item)
            }
            return options
        }
    }
    
    var currentSupplier : Producer? = nil
    
    var delegate : SupplierChangedDelegate? = nil
    
    
    // MARK: - UITableView lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}








