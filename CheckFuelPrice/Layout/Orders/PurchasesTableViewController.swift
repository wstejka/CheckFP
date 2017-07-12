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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = model[collectionView.tag][indexPath.row]
        
        return cell
    }
}

extension PurchasesTableViewController: UICollectionViewDelegate {
    
}



class PurchasesTableViewController: UITableViewController {

    // MARK: - Vars/Consts
    let model : [[UIColor]] = [[.red, .blue, .green, .orange, .purple],
                               [ThemesManager.get(color: .primary),
                                ThemesManager.get(color: .color1),
                                ThemesManager.get(color: .color2),
                                ThemesManager.get(color: .color3)],
                               [.aquaCrayonColor, .cantalopeCrayonColor, .iceCrayonColor, .midnightCrayonColor, .oceanCrayonColor, .skyCrayonColor, .tangerineCrayonColor, .aquaHTMLColor, .burlyWoodHTMLColor],
                               [.cornflowerBlueHTMLColor, .darkBlueHTMLColor, .goldHTMLColor, .goldenRodHTMLColor, .darkGoldenRodHTMLColor, .darkorangeHTMLColor, .deepSkyBlueHTMLColor, .dodgerBlueHTMLColor],
                               [.fireBrickHTMLColor, .indigoHTMLColor, .lightBlueHTMLColor, .lightCyanHTMLColor, .lightSalmonHTMLColor, .lightSkyBlueHTMLColor, .lightSteelBlueHTMLColor, .mediumVioletRedHTMLColor],
                               [.moccasinHTMLColor, .navajoWhiteHTMLColor, .navyHTMLColor, .orangeHTMLColor, .orangeRedHTMLColor, .papayaWhipHTMLColor, .peachPuffHTMLColor, .peruHTMLColor],
                               [.purpleHTMLColor, .royalBlueHTMLColor, .salmonHTMLColor, .sandyBrownHTMLColor, .skyBlueHTMLColor, .steelBlueHTMLColor, .yellowGreenHTMLColor]]
    
    var storedOffsets : [Int : CGFloat] = [:]
    
    
    // MARK: - Outlets
    
    // MARK: - UITableViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }



    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
