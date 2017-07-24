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
            guard let cell = self.dataTableView.dequeueReusableCell(withIdentifier: fuelInfoTableCellIdentifier,
                                                                               for: indexPath) as? FuelInfoTopTableViewCell else {
                                                                                return UITableViewCell()
            }
            
            for imagePosition in dataForCell.keys {
                
                var imageLabel : UILabel = cell.leftImageDescriptionLabel
                var imageView : UIImageView = cell.leftImage
                if imagePosition == .right {
                    imageLabel = cell.rightImageDescriptionLabel
                    imageView = cell.rightImage
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
                
                imageLabel.text = description.localized(withDefaultValue: "").capitalizingFirstLetter()
                imageView.image = UIImage(named: imageName)
                
                // Configure tap gesture for first image
                let imageGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                         action: selector)
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(imageGestureRecognizer)
                imageView.layer.cornerRadius = Utils.defaultCornerRadius
                imageView.clipsToBounds = true
                
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 2000, bottom: 0, right: 0)
            
            return cell
        }
        else {

            guard let cell = self.dataTableView.dequeueReusableCell(withIdentifier: fuelInfoThirdTableViewCell,
                                                                               for: indexPath) as? FuelInfoThirdTableViewCell else {
                                                                                return UITableViewCell()
            }
            
            cell.accessoryType = .disclosureIndicator
            cell.customImageView!.clipsToBounds = true
            cell.customImageView?.image = UIImage(named: "bell")
            cell.customImageView?.contentMode = .scaleAspectFill
            cell.customTitle?.text = "notifications".localized().capitalizingFirstLetter()

            return cell
        }
        
    }
    
    
    func currentFuelPricesImageTapped(tapGestureRecognizer : UITapGestureRecognizer) {
        log.verbose("Enter")
        performSegue(withIdentifier: ViewSegue.FuelPricesSegue.rawValue, sender: nil)
    }

    func purchasesImageTapped(tapGestureRecognizer : UITapGestureRecognizer) {
        log.verbose("Enter")
        performSegue(withIdentifier: ViewSegue.PurchasesSegue.rawValue, sender: nil)

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == CustomCellId.fuelBottomRow.rawValue {
            performSegue(withIdentifier: ViewSegue.NotificationsSegue.rawValue, sender: nil)
        }
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
        case purchases      = "Purchases"
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
        case PurchasesSegue     = "PurchasesSegue"
        case StatisticsSegue    = "StatisticsSegue"
        case SettingsSegue      = "SettingsSegue"
        case NotificationsSegue = "NotificationsSegue"
    }
    
    let fuelInfoTableCellIdentifier = "fuelInfoTableCellIdentifier"
    let fuelInfoThirdTableViewCell = "FuelInfoThirdTableViewCell"
    
    
    let getTilesData = { () -> [Int : Dictionary<FuelInfoViewController.ImagePosition, [FuelInfoViewController.ImageProperties : Any]>] in
        
        let currentPrices = [ImageProperties.image : "FuelPump",
                             ImageProperties.description : "currentFuelPrices",
                             ImageProperties.selector : #selector(currentFuelPricesImageTapped)] as [FuelInfoViewController.ImageProperties : Any]
        
        let purchases = [ImageProperties.image : "Purchases",
                         ImageProperties.description : "purchases",
                         ImageProperties.selector : #selector(purchasesImageTapped)] as [FuelInfoViewController.ImageProperties : Any]
        
        let statistics = [ImageProperties.image : "Statistics",
                          ImageProperties.description : "statistics",
                          ImageProperties.selector : #selector(statisticsImageTapped)] as [FuelInfoViewController.ImageProperties : Any]
        
        let settings = [ImageProperties.image : "Settings2",
                        ImageProperties.description : "settings",
                        ImageProperties.selector : #selector(settingsImageTapped)] as [FuelInfoViewController.ImageProperties : Any]
        
        let tilesDict = [CustomCellId.fuelDataRow.rawValue :
                            [ImagePosition.left : currentPrices,
                             ImagePosition.right: purchases],
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

        let sectionBottomNib = UINib(nibName: "FuelInfoThirdCell", bundle: nil)
        self.dataTableView.register(sectionBottomNib, forCellReuseIdentifier: fuelInfoThirdTableViewCell)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        log.verbose("")
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        deselectHighlightedRow()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        log.verbose("")
        AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight])
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
    @IBAction func unwindToFuelInfoAndSingOut(sender: UIStoryboardSegue) {
        
        log.verbose("entered")
        try! Auth.auth().signOut()
    }

}
