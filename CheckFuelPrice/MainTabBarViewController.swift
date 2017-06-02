//
//  MainTabBarViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 02/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainTabNamesList : [String?] = ["mainTab1Name", "mainTab2Name"]
        
        // Let's name the tabs depend on the language
        var counter = 0
        for viewController in self.viewControllers! {

            // Ensure index os not out of range
            if counter >= mainTabNamesList.count {
                log.error("Index out of range. Add missing values or remove view controler")
                break
            }
            let tabName = mainTabNamesList[counter]?.localized(withDefaultValue: "")
            viewController.tabBarItem?.title = tabName
            // increment counter
            counter += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
