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
        log.verbose("Enter")
        
        return predefinedNumberOfTableRow
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == customCellId.fuelDataRow.rawValue {

            guard let fuelInfoTopCell = self.dataTableView.dequeueReusableCell(withIdentifier: "FuelInfoTopTableViewCell",
                                                                               for: indexPath) as? FuelInfoTopTableViewCell else {
                return UITableViewCell()
            }
            
            fuelInfoTopCell.leftImageDescriptionLabel.text = "currentFuelPrices".localized(withDefaultValue: "")
            fuelInfoTopCell.rightImageDescriptionLabel.text = "statistics".localized(withDefaultValue: "")
            
            
            let imageList = [fuelInfoTopCell.leftImage, fuelInfoTopCell.rightImage]
            
            // Top Left image
            fuelInfoTopCell.leftImage.image = UIImage(named: fuelImages.currentPrices.rawValue)
            // Configure tap gesture for first image
            let topLeftImageGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                       action: #selector(topLeftImageTapped))
            fuelInfoTopCell.leftImage.isUserInteractionEnabled = true
            fuelInfoTopCell.leftImage.addGestureRecognizer(topLeftImageGestureRecognizer)
            
            
            // Top Right image
            fuelInfoTopCell.rightImage.image = UIImage(named: fuelImages.settings.rawValue)
            // Configure tap gesture for first image
            let topRightImageGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                       action: #selector(topRightImageTapped))
            fuelInfoTopCell.rightImage.isUserInteractionEnabled = true
            fuelInfoTopCell.rightImage.addGestureRecognizer(topRightImageGestureRecognizer)

            
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
        if indexPath.row == customCellId.fuelDataRow.rawValue {
            return false
        }
        return true
    }
    
}

class FuelInfoViewController: UIViewController {


    // MARK: - constants
    let predefinedNumberOfTableRow =  customCellId.elementsCount
    enum customCellId : Int {
        case fuelDataRow = 0
        case fuelSettingsRow
        case fuelBottomRow
    }
    
    enum fuelImages :String {
        case currentPrices = "FuelPump"
        case settings = "Statistics"
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
