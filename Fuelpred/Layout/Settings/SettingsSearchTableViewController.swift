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
    
    func selected(search option: SettingsMatchingItem)
}

// MARK: Extension UISearchResultsUpdating
extension SettingsSearchTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        log.verbose("")
        
        self.matchingItems = []
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        for item in sectionConfigAsList {
            
            let matchingSubstringRange = item.text.lowercased().range(of: searchText)
            if matchingSubstringRange == nil {
                continue
            }
            let attributedString = NSMutableAttributedString(string: item.text,
                                                             attributes: [:])
            
            attributedString.setAttributes([NSForegroundColorAttributeName : ThemesManager.get(color: .primary),
                                            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18.0)],
                                           range: String().nsRange(from: matchingSubstringRange!))
            var itemCopy = item
            itemCopy.attributedText = attributedString
            self.matchingItems.append(itemCopy)
        }
        tableView.reloadData()
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
        cell.textLabel?.attributedText = matchingItem.attributedText
        
        cell.detailTextLabel?.text = matchingItem.detailText
        
        return cell
    }
}

// MARK: - Extension Table view delegate
extension SettingsSearchTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selected = self.matchingItems[indexPath.row]
        
        log.verbose("didSelectRowAt: section=\(selected.section), row=\(selected.row)")
        self.delegate?.selected(search: selected)
        dismiss(animated: true, completion: nil)
    }
}


struct SettingsMatchingItem {
    
    var text : String
    var attributedText : NSAttributedString
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
            
            
            for sectionPos in iterateEnum(SettingsTableViewController.SettingSection.self) {
                guard let values = sectionsConf[sectionPos] else {
                    log.error("Cannot find node associated with \(sectionPos)")
                    return []
                }
                
                guard let sectionHeaderText = values[Utils.TableSections.header] as? String,
                    let sectionBody = values[Utils.TableSections.body] as? [String] else {
                        log.error("Cannot get data for section")
                        return []
                }
                
                for pos in 0...(sectionBody.count - 1) {

                    let settingsItem =  SettingsMatchingItem(text: sectionBody[pos], attributedText: NSAttributedString(),
                                                             detailText: sectionHeaderText,
                                                             section: sectionPos.rawValue, row: pos)

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
