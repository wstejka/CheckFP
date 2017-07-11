//
//  SettingsSearchTableViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 03/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

// MARK: Protocol HandleSettingSearchDelegate
protocol HandleSettingSearchDelegate {
    
    func selected(search option: SettingsTableViewController.SelectedRow)
}

// MARK: Extension UISearchResultsUpdating
extension SettingsSearchTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        log.verbose("")
        
        self.matchingItems = []
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        for item in sectionConfigAsList {
            
            // alternative: not case sensitive
            if item.text.lowercased().range(of: searchText) != nil {
                self.matchingItems.append(item)
            }
            tableView.reloadData()
        }
        
    }

}

// MARK: Extension Table view data source
extension SettingsSearchTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            log.error("Could not create Cell object")
            return UITableViewCell()
        }
        let matchingItem = matchingItems[indexPath.row]
        cell.textLabel?.text = matchingItem.text
        
        let detailText = matchingItem.section
        cell.detailTextLabel?.text = String(detailText)
        
        return cell
    }
}


struct SettingsMatchingItem {
    
    let text : String
    let detailText : String
    let section : Int
    let row : Int
}

class SettingsSearchTableViewController: UITableViewController {

    
    // MARK: Variables/Constants
    var sectionsConfig : SettingsTableViewController.ConfigType? = nil
    var delegate : HandleSettingSearchDelegate? = nil
    
    // This computed variable returns options ordered as list instead of dict
    var sectionConfigAsList : [SettingsMatchingItem] {
        
        get {
            
            var list : [SettingsMatchingItem] = []
            guard let sectionsConf = sectionsConfig else {
                return []
            }
            
            // TODO: to guarantee ordering we need to increment through position
            for (key, values) in sectionsConf {
                
                let sectionPos = key.rawValue
                
                guard let sectionHeaderText = values[Utils.TableSections.header] as? String,
                    let sectionBody = values[Utils.TableSections.body] as? [String] else {
                        log.error("Cannot get data for section")
                        return []
                }
                
                for pos in 0...(sectionBody.count - 1) {

                    let settingsItem =  SettingsMatchingItem(text: sectionBody[pos], detailText: sectionHeaderText,
                                                             section: sectionPos, row: pos)

                    list.append(settingsItem)
                }
            }
            
            return list
        }
    }
    
    var matchingItems : [SettingsMatchingItem] = []
    
    // MARK: UITableViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

    }

}
