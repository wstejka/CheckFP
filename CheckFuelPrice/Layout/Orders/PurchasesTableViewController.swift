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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        log.verbose("\(model.count)")
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Remark: we need only 1 row per day as particular purchase are shown invarlection
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        log.verbose("cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let currentDate = model[section].first
        return currentDate?.humanReadableDate
    }
    
}

// MARK: - Extension: Table view delegate
extension PurchasesTableViewController {

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? PurchasesTableViewCell else {
            return
        }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
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
        cell.section = collectionView.tag
        cell.row = indexPath.row
        cell.layer.cornerRadius = 10.0
        cell.backgroundColor = UIColor.flatWhite()
        
        let item = model[collectionView.tag][indexPath.row]
        
        let fuelTypeView = cell.fuelTypeView.addXib(forType: FuelTypeView.self)
        Utils.setupFuelType(view: fuelTypeView, forType: item.fuelType)
        
        let amount = item.amount
        let price = item.price
        let value = amount * price
        cell.amountLabel.text = "amount".localized() + ":"
        cell.amountValueLabel.text = amount.strRound(to: 2)
        
        cell.priceLabel.text = "price".localized() + ":"
        cell.priceValueLabel.text = price.strRound(to: 2)
        
        cell.valueLabel.text = "value".localized() + ":"
        cell.valueValueLabel.text = value.strRound(to: 2)
        
        
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        cell.addGestureRecognizer(pressGesture)
        
        return cell
    }
}

extension PurchasesTableViewController: UICollectionViewDelegate {
    
    func longPressGesture(sender: UILongPressGestureRecognizer) {
        
        
        guard let cell = sender.view as? PurchasesCollectionViewCell else {
            log.error("Incorrect type of view. Cannot cast to PurchasesCollectionViewCell")
            return
        }
        if sender.state == UIGestureRecognizerState.began {
            log.verbose("state: \(sender.state), row: \(cell.row), section: \(cell.section)")
         
            let alertController = UIAlertController(title: "", message: "selectOption".localized(),
                                                    preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let removeOption = UIAlertAction(title: "remove".localized().capitalizingFirstLetter(), style: UIAlertActionStyle.destructive, handler: { action in
                                            
                                            
                
            })
            let editOption = UIAlertAction(title: "edit".localized().capitalizingFirstLetter(), style: UIAlertActionStyle.default, handler: { action in
                                            
                self.processEdit(cell: cell)
                
            })
            let cancelOption = UIAlertAction(title: "cancel".localized().capitalizingFirstLetter(),
                                             style: UIAlertActionStyle.cancel, handler: { (action) in
                                                
            })
            
            alertController.addAction(removeOption)
            alertController.addAction(editOption)
            alertController.addAction(cancelOption)
            present(alertController, animated: true, completion: nil)
            
        }
    }

}



class PurchasesTableViewController: UITableViewController {

    // MARK: - Vars/Consts

    var model : [[FuelPurchase]] = []
    var storedOffsets : [Int : CGFloat] = [:]
    
    var purchaseRef : DatabaseReference? = nil
    
    let purchaseUpdateViewControllerSegue = "PurchaseUpdateViewControllerSegue"
    
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
    
    func processEdit(cell: PurchasesCollectionViewCell?) {
        log.verbose("")
        
        guard let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "PurchaseUpdateNavigationViewController") as? UINavigationController else {
            log.error("Could not instantiate \"PurchaseUpdateNavigationViewController\" object")
            return
        }
        if let cell = cell {
            // if cell is not empty it means user edits existing cell
            // In that case let's copy snapshot information
            let purchaseUpdateVC = navigationViewController.topViewController as? PurchaseUpdateViewController
            purchaseUpdateVC?.snapshot = self.model[cell.section][cell.row]
        }
        
        navigationViewController.modalTransitionStyle = .coverVertical
        self.present(navigationViewController, animated: true, completion: nil)

    }

}
