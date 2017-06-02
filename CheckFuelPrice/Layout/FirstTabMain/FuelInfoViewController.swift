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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        log.verbose("Enter 1")
        
        return predefinedNumberOfTableRow
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == customCellId.fuelTopRow.rawValue {

            guard let fuelInfoTopCell = self.dataTableView.dequeueReusableCell(withIdentifier: "FuelInfoTopTableViewCell",
                                                                               for: indexPath) as? FuelInfoTopTableViewCell else {
                return UITableViewCell()
            }
            
            fuelInfoTopCell.settingsLabel.text = "settings".localized(withDefaultValue: "")
            fuelInfoTopCell.fuelPriceLabel.text = "currentFuelPrices".localized(withDefaultValue: "")
            
            
            let imageList = [fuelInfoTopCell.topLeftImage, fuelInfoTopCell.topRightImage,
                             fuelInfoTopCell.bottomLeftImage, fuelInfoTopCell.bottomRightImage]
            
            // Top Left image
            fuelInfoTopCell.topLeftImage.image = UIImage(named: fuelImages.currentPrices.rawValue)
            // Configure tap gesture for first image
            let topLeftImageGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                       action: #selector(topLeftImageTapped))
            fuelInfoTopCell.topLeftImage.isUserInteractionEnabled = true
            fuelInfoTopCell.topLeftImage.addGestureRecognizer(topLeftImageGestureRecognizer)
            
            
            // Top Right image
            fuelInfoTopCell.topRightImage.image = UIImage(named: fuelImages.settings.rawValue)
            // Configure tap gesture for first image
            let topRightImageGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                       action: #selector(topRightImageTapped))
            fuelInfoTopCell.topRightImage.isUserInteractionEnabled = true
            fuelInfoTopCell.topRightImage.addGestureRecognizer(topRightImageGestureRecognizer)

            
            // Configure all images properties
            for imageView in imageList {
                imageView?.layer.cornerRadius = 20
                imageView?.clipsToBounds = true
            }

            return fuelInfoTopCell
        }
        else {
            let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
    }
    
    func topLeftImageTapped(tapGestureRecognizer : UITapGestureRecognizer) {
        log.verbose("Enter")
        performSegue(withIdentifier: "FuelPricesSegue", sender: nil)
    }

    func topRightImageTapped(tapGestureRecognizer : UITapGestureRecognizer) {
        log.verbose("Enter")
        performSegue(withIdentifier: "SettingsSegue", sender: nil)

    }

}

// MARK: - UITableView Delegate methods
extension FuelInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        log.verbose("Enter: \(indexPath.row)")
        if indexPath.row == customCellId.fuelTopRow.rawValue {
            return false
        }
        return true
    }
    
}

class FuelInfoViewController: UIViewController {


    // MARK: - constants
    let predefinedNumberOfTableRow =  customCellId.elementsCount
    enum customCellId : Int {
        case fuelTopRow = 0
        case fuelInfoMiddle
        case fuelInfoBottom
    }
    
    enum fuelImages :String {
        case currentPrices = "FuelPump"
        case settings = "Settings2"
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
        
//        self.navigationController?.tabBarItem.title = "Test"
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
