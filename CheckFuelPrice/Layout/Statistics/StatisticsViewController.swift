//
//  StatisticsViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit



protocol StatisticsViewControllerDelegate {
    
    func selectedFuel(name : FuelName)
}

// MARK: - UICollectionViewDataSource lifecycle
extension StatisticsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "StatisticsCollectionViewCell", for: indexPath) as? StatisticsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let fuelType = self.items[indexPath.row]
        cell.imageView.image = UIImage(named: fuelType.name)
        cell.imageView.layer.cornerRadius = 10
        cell.imageView.clipsToBounds = true
        if indexPath.row != (selectedFuelName.hashValue - 1) {
            cell.isSelected = false
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
}

// MARK: - UICollectionViewDelegate lifecycle

extension StatisticsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        log.debug("entered: \(indexPath)")
        
        let fuelType = items[indexPath.row]
        guard let fuelName = FuelName(rawValue: fuelType.name) else {
            return
        }
        self.selectedFuelName = fuelName
        collectionView.deselectAllItemsExcept(indexPath)
    }

}


class StatisticsViewController: UIViewController {
    
    
    // MARK: - constants
    var items : [FuelType] = []
    var refFuelTypes : DatabaseReference? = nil
    let defaultSection = 0

    // delegate
    var delegate : StatisticsViewControllerDelegate?
    
    // selected fuel type
    var selectedFuelName : FuelName = FuelName.unleaded95 {
        
        didSet {
            delegate?.selectedFuel(name: selectedFuelName)
        }
    }
    
    // MARK: - properties
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        log.verbose("entered")

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // Instantiate StatisticsPageViewController
        let statisticsPageVC = UIStoryboard(name: "Statistics", bundle: nil).instantiateViewController(withIdentifier: "StatisticsPageViewController") as! StatisticsPageViewController
        // Do all work to put StatisticsPageViewController object into container
        self.addViewControllerTo(container: statisticsPageVC)
        // Set Page View Controller as a delegate of this class
        self.delegate = statisticsPageVC
        
        // Set default fuelName. It must be done after setting up delegation
        self.selectedFuelName = FuelName.unleaded95

        // Configure reference to firebase node
        self.refFuelTypes = Database.database().reference(withPath: FirebaseNode.fuelType.rawValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startObserving()
    }

    override func viewDidDisappear(_ animated: Bool) {
        if self.refFuelTypes != nil {
            // remove observer
            self.refFuelTypes!.removeAllObservers()
            log.verbose("Observer for node \(FirebaseNode.fuelType.rawValue) removed")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Added for debugging purpose
    deinit {
        log.verbose("")
    }
    
    // MARK: - Actions

    
    // MARK: - Methods
    
    func startObserving() {
        log.verbose("")
        
        // to avoid retain cycle let's pass weak reference to self
        self.refFuelTypes!.queryOrdered(byChild: "id").observe(.value, with: { [weak self] snapshot in
            guard let selfweak = self else {
                return
            }
            
            log.verbose("Returned: \(selfweak.refFuelTypes!.description()) \(snapshot.childrenCount)")
            var newItems: [FuelType] = []
            
            for item in snapshot.children {
                guard let fuelType = FuelType(snapshot: item as! DataSnapshot) else {
                    continue
                }
                // ignore fuel types with zero/not obtained value
                if fuelType.currentHighestPrice == 0.0 {
                    continue
                }
                
                newItems.append(fuelType)
            }
            selfweak.items = newItems
            selfweak.collectionView.reloadData()
        })
    }
    
    //! Adding given View Controller to container view programmatically
    /*! Remark: I could instantiate VC in container using storyboard features ("embed" segue)
                and then set delegate in prepare:forSegue method
                This way is to show it can be done programmatically, as well
    */
    func addViewControllerTo(container uiViewController : UIViewController) {
        log.verbose("entered")
        // Tell ViewController to start managing uiViewController
        self.addChildViewController(uiViewController)
        // Set the size of given VC the same as container
        // Note that container is stretched in storyboard by the constraints
        uiViewController.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width,
                                             height: self.containerView.frame.size.height)
        // Add View of given VC as a subview of container
        self.containerView.addSubview(uiViewController.view)
        // Make child VC aware about parent
        uiViewController.didMove(toParentViewController: self)
    }
    
}
