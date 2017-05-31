//
//  FuelInfoViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 30/05/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

// MARK: - UITableView source methods
extension FuelInfoViewController: UITableViewDataSource {
    
    // MARK: - UITableView Delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predefinedNumberOfTableRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == customCellId.fuelInfoTop.rawValue {

            guard let fuelInfoTopCell = self.dataTableView.dequeueReusableCell(withIdentifier: "FuelInfoTopTableViewCell", for: indexPath) as? FuelInfoTopTableViewCell else {
                return UITableViewCell()
            }
            fuelInfoTopCell.topLeftImage.image = UIImage(named: "Gas Station")
            fuelInfoTopCell.topRightImage.image = UIImage(named: "PieChart")
            fuelInfoTopCell.bottomLeftImage.image = UIImage(named: "PieChart")
            fuelInfoTopCell.bottomRightImage.image = UIImage(named: "Gas Station")
            
            fuelInfoTopCell.topLeftImage.layer.cornerRadius = 10
            fuelInfoTopCell.topLeftImage.clipsToBounds = true
            

            return fuelInfoTopCell
        }
        else {
            return UITableViewCell()
        }
        
    }
}

extension FuelInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        log.verbose("Enter: \(indexPath.row)")
        if indexPath.row == customCellId.fuelInfoTop.rawValue {
            return false
        }
        return true
    }
    
}

class FuelInfoViewController: UIViewController {


    // MARK: - constants
    let predefinedNumberOfTableRow =  customCellId.elementsCount
    enum customCellId : Int {
        case fuelInfoTop = 0
        case fuelInfoMiddle
        case fuelInfoBottom
    }
    
    // MARK: - properties
    @IBOutlet weak var dataTableView: UITableView!
    
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        log.verbose("Enter")
        self.dataTableView.dataSource = self
        self.dataTableView.delegate = self
        
        // Do any additional setup after loading the view.
        self.dataTableView.rowHeight = UITableViewAutomaticDimension
        self.dataTableView.estimatedRowHeight = 200
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    // MARK: - Actions
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
