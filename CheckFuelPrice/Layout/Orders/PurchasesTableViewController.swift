//
//  PurchasesTableViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

// MARK: - Extension: Table view data source
extension PurchasesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        return cell
    }
    
}

// MARK: - Extension: Table view delegate
extension PurchasesTableViewController {

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? PurchasesTableViewCell else {
            return
        }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? PurchasesTableViewCell else {
            return
        }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

// MARK: - Extension: CollectionViewDataSource
extension PurchasesTableViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[collectionView.tag].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PurchasesCollectionViewCell else {
            return UICollectionViewCell()
        }
//        cell.backgroundColor = model[collectionView.tag][indexPath.row] 
        
        cell.fuelTypeButton.layer.cornerRadius = 10.0
        let item = model[collectionView.tag][indexPath.row]
        
        cell.fuelTypeLabel.text = Fuel(rawValue: item.fuelType)?.getLocalizedText()
        
        let amount = item.amount
        let price = item.price
        let value = amount * price
        cell.amountLabel.text = "amount:"
        cell.amountValueLabel.text = String(amount)
        
        cell.priceLabel.text = "price:"
        cell.priceValueLabel.text = String(price)
        
        cell.valueLabel.text = "value:"
        cell.valueValueLabel.text = String(value)
        
        return cell
    }
}

extension PurchasesTableViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        log.verbose("didSelectItemAt: \(collectionView.tag)\\\(indexPath.row)")
    }
}



class PurchasesTableViewController: UITableViewController {

    // MARK: - Vars/Consts

    var model : [[FuelPurchase]] = []
    var storedOffsets : [Int : CGFloat] = [:]
    
    var purchaseRef : DatabaseReference? = nil
    
    // MARK: - Outlets
    
    // MARK: - UITableViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display "+" button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,
                                                                 target: self, action: #selector(addButtonPressed))
        
        // Set up reference to purchase node
        purchaseRef = Database.database().reference(withPath: FirebaseNode.fuelPurchase.rawValue)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        self.startObserving()
    }

    override func viewDidDisappear(_ animated: Bool) {

        if self.purchaseRef != nil {
            purchaseRef?.removeAllObservers()
        }
        
    }
    

    // MARK: Methods
    func addButtonPressed(tapGestureRecognizer : UITapGestureRecognizer) {
        log.verbose("")
    }
    
    func startObserving() {
        guard let uid = Auth.auth().currentUser?.uid else {
            log.error("This user is not authenticated.")
            return
        }
        log.verbose("uid: \(String(describing: uid))")
        purchaseRef?.child(uid).queryOrderedByKey().observe(.value, with: { (snapshot) in
            
            log.verbose("Snapshot: \(snapshot)")
  
            // We need to use auxiliary dict for combining data per timestamp
            var snapshotDict : [Int : [FuelPurchase]] = [:]
            for item in snapshot.children {
                
                guard let purchase = FuelPurchase(snapshot: item as! DataSnapshot) else {
                    continue
                }
                
                // check if there is alrady node idnetified by the timestamp
                if let _ = snapshotDict[purchase.timestamp] {
                    snapshotDict[purchase.timestamp]?.append(purchase)
                }
                else {
                    snapshotDict[purchase.timestamp] = [purchase]
                }
            }
            
            // Let's now populate data in model array
            self.model = []
            for key in snapshotDict.keys.sorted() {
                
                guard let purchases = snapshotDict[key] else {
                    continue
                }
                self.model.append(purchases)
            }
            self.tableView.reloadData()
        })
        
    }

}
