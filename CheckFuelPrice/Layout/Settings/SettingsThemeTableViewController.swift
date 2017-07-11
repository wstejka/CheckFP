//
//  SettingsThemeTableViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 09/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

// MARK: - Protocol ThemeChangedDelegate
protocol ThemeChangedDelegate {
    
    func selected(theme: ThemesManager.Theme)
}

// MARK: - Table view data source
extension SettingsThemeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath) as? SettingsThemeTableViewCell else {
            log.error("Could not cast cell to setting theme one")
            return UITableViewCell()
        }
        
        // Configure the cell...
        let theme = items[indexPath.row]
        let themeName = String(describing: theme)
        cell.descriptionLabel?.text = themeName.capitalizingFirstLetter()
        
        // Get theme colors set
        if let themeColors = ThemesManager.themeColors[theme] {
            
            if themeColors.count >= 5 {
                cell.color0Label.backgroundColor = themeColors[0]
                cell.color1Label.backgroundColor = themeColors[1]
                cell.color2Label.backgroundColor = themeColors[3]
                cell.color3Label.backgroundColor = themeColors[4]
            }
            else {
                cell.color0Label.backgroundColor = .white
                cell.color1Label.backgroundColor = .white
                cell.color2Label.backgroundColor = .white
                cell.color3Label.backgroundColor = .white
            }
            
        }
        
        
        if theme == currentTheme {
            cell.descriptionLabel?.textColor = ThemesManager.get(color: .primary)
        }
        
        return cell
    }
    
}

// MARK: - Extension - Table view delegate
extension SettingsThemeTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        log.verbose("didSelectRowAt")
        
        let theme = items[indexPath.row]
        delegate?.selected(theme: theme)
        _ = navigationController?.popViewController(animated: true)
        
    }
}

class SettingsThemeTableViewController: UITableViewController {
    
    // MARK: Vars/Consts
    var items : [ThemesManager.Theme] {
        
        get {
            var options : [ThemesManager.Theme] = []
            for item in iterateEnum(ThemesManager.Theme.self) {
                options.append(item)
            }
            return options
        }
    }
    
    var currentTheme : ThemesManager.Theme? = nil
    
    var delegate : ThemeChangedDelegate? = nil
    
    // MARK: - Outlets

    
    // MARK: - UITableView lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
