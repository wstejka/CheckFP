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
        
        
        if indexPath.row < CustomCellId.fuelBottomRow.rawValue {
            
            
            guard let dataForCell = self.getTilesData[indexPath.row] else {
                return UITableViewCell()
            }
            guard let fuelInfoTopCell = self.dataTableView.dequeueReusableCell(withIdentifier: fuelInfoTableCellIdentifier,
                                                                               for: indexPath) as? FuelInfoTopTableViewCell else {
                                                                                return UITableViewCell()
            }
            
            for imagePosition in dataForCell.keys {
                
                var imageLabel : UILabel = fuelInfoTopCell.leftImageDescriptionLabel
                var imageView : UIImageView = fuelInfoTopCell.leftImage
                if imagePosition == .right {
                    imageLabel = fuelInfoTopCell.rightImageDescriptionLabel
                    imageView = fuelInfoTopCell.rightImage
                }

                guard let imageProperties = dataForCell[imagePosition] else {
                    return UITableViewCell()
                }
                guard let description = imageProperties[.description] as? String else {
                    return UITableViewCell()
                }
                guard let imageName = imageProperties[.image] as? String  else {
                    return UITableViewCell()
                }
                guard let selector = imageProperties[.selector] as? Selector else {
                    return UITableViewCell()
                }
                
                imageLabel.text = description.localized(withDefaultValue: "")
                imageView.image = UIImage(named: imageName)
                
                // Configure tap gesture for first image
                let imageGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                         action: selector)
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(imageGestureRecognizer)
                imageView.layer.cornerRadius = 20
                imageView.clipsToBounds = true
                
            }
            fuelInfoTopCell.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
            
            return fuelInfoTopCell
        }
        else {
            let cell = UITableViewCell()
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
    }
    
    func currentFuelPricesImageTapped(tapGestureRecognizer : UITapGestureRecognizer) {
        log.verbose("Enter")
        performSegue(withIdentifier: ViewSegue.FuelPricesSegue.rawValue, sender: nil)
    }

    func OrdersImageTapped(tapGestureRecognizer : UITapGestureRecognizer) {
        log.verbose("Enter")
        performSegue(withIdentifier: ViewSegue.OrdersSegue.rawValue, sender: nil)

    }
    
    func statisticsImageTapped(tapGestureRecognizer : UITapGestureRecognizer) {
        log.verbose("Enter")
        performSegue(withIdentifier: ViewSegue.StatisticsSegue.rawValue, sender: nil)
    }

    func settingsImageTapped(tapGestureRecognizer : UITapGestureRecognizer) {
        log.verbose("Enter")
        performSegue(withIdentifier: ViewSegue.SettingsSegue.rawValue, sender: nil)
    }

}

// MARK: - UITableView Delegate methods
extension FuelInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        log.verbose("Enter: \(indexPath.row)")
        if indexPath.row < CustomCellId.fuelBottomRow.rawValue {
            return false
        }
        return true
    }
    
}

class FuelInfoViewController: UIViewController {


    // MARK: - Constants
    let predefinedNumberOfTableRow =  CustomCellId.elementsCount
    enum CustomCellId : Int {
        case fuelDataRow = 0
        case fuelSettingsRow
        case fuelBottomRow
    }
    
    enum FuelImages :String {
        case currentPrices  = "FuelPump"
        case orders         = "Orders"
        case statistics     = "Statistics"
        case settings       = "Settings2"
    }
    
    enum ImagePosition {
        case left
        case right
    }
    
    enum ImageProperties {
        case image
        case description
        case selector
    }
    
    enum ViewSegue : String {
        case FuelPricesSegue    = "FuelPricesSegue"
        case OrdersSegue        = "OrdersSegue"
        case StatisticsSegue    = "StatisticsSegue"
        case SettingsSegue      = "SettingsSegue"
    }
    
    let fuelInfoTableCellIdentifier = "fuelInfoTableCellIdentifier"
    
    
    let getTilesData = { () -> [Int : Dictionary<FuelInfoViewController.ImagePosition, [FuelInfoViewController.ImageProperties : Any]>] in
        
        let currentPrices = [ImageProperties.image : "FuelPump",
                             ImageProperties.description : "currentFuelPrices",
                             ImageProperties.selector : #selector(currentFuelPricesImageTapped)] as [FuelInfoViewController.ImageProperties : Any]
        
        let orders = [ImageProperties.image : "Orders",
                      ImageProperties.description : "orders",
                      ImageProperties.selector : #selector(OrdersImageTapped)] as [FuelInfoViewController.ImageProperties : Any]
        
        let statistics = [ImageProperties.image : "Statistics",
                          ImageProperties.description : "statistics",
                          ImageProperties.selector : #selector(statisticsImageTapped)] as [FuelInfoViewController.ImageProperties : Any]
        
        let settings = [ImageProperties.image : "Settings2",
                        ImageProperties.description : "settings",
                        ImageProperties.selector : #selector(settingsImageTapped)] as [FuelInfoViewController.ImageProperties : Any]
        
        let tilesDict = [CustomCellId.fuelDataRow.rawValue :
                            [ImagePosition.left : currentPrices,
                             ImagePosition.right: orders],
                         CustomCellId.fuelSettingsRow.rawValue :
                            [ImagePosition.left : statistics,
                             ImagePosition.right: settings]
            ]
        
        return tilesDict
    }()
    
    
    // MARK: - Properties
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
        
        // Register Xib
        let sectionHeaderNib = UINib(nibName: "CustomCell", bundle: nil)
        self.dataTableView.register(sectionHeaderNib, forCellReuseIdentifier: fuelInfoTableCellIdentifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        deselectHighlightedRow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Methods
    
    func deselectHighlightedRow() {
        if let lastSelectedRow = self.dataTableView.indexPathForSelectedRow {
            self.dataTableView.deselectRow(at: lastSelectedRow, animated: false)
        }
        
    }
    
    // MARK: - Actions

}