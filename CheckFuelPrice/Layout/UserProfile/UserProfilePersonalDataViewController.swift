//
//  UserProfilePersonalDataViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 24/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

extension UserProfilePersonalDataViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as? UserProfilePersonalDataTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    
    
}

class UserProfilePersonalDataViewController: UIViewController {

    // MARK: Variable/Constants
//    let
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
}
