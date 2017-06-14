//
//  StatisticsViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit



protocol StatisticsViewControllerDelegate {
    
    func selectedFuel(type : FuelName)
}

extension StatisticsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "StatisticsCollectionViewCell", for: indexPath) as? StatisticsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let fuelType = self.items[indexPath.row]
        cell.imageView.image = UIImage(named: fuelType.name)
        cell.imageView.layer.cornerRadius = 10
        cell.imageView.clipsToBounds = true
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
}

extension StatisticsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? StatisticsCollectionViewCell else {
            log.error("Cannot find cell at index \(indexPath.row)")
            return
        }

        cell.imageView.layer.borderColor = UIColor.gray.cgColor
        cell.imageView.layer.borderWidth = 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? StatisticsCollectionViewCell else {
            log.error("Cannot find cell at index \(indexPath.row)")
            return
        }
        
        cell.imageView.layer.borderColor = UIColor.white.cgColor
        cell.imageView.layer.borderWidth = 0.0
        
    }
}


class StatisticsViewController: UIViewController {
    
    
    // MARK: - constants
    var items : [FuelType] = []
    var refFuelTypes : DatabaseReference? = nil
    var observerHandle : DatabaseHandle = 0
    
    // MARK: - properties
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // delegate
    var delegate : StatisticsViewControllerDelegate?
    

    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        log.verbose("entered")

        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        // Configure reference to firebase node
        self.refFuelTypes = Database.database().reference(withPath: FirebaseNode.fuelType.rawValue)
        DispatchQueue.global().async {
            // to avoid retain cycle let's pass weak reference to self
            self.observerHandle = self.refFuelTypes!.queryOrdered(byChild: "id").observe(.value, with: { [weak self] snapshot in
                guard let selfweak = self else {
                    return
                }
                
                log.verbose("Observe: \(selfweak.refFuelTypes!.description()) \(snapshot.childrenCount)")
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
        
        // Instantiate StatisticsPageViewController
        let statisticsPageVC = UIStoryboard(name: "Statistics", bundle: nil).instantiateViewController(withIdentifier: "StatisticsPageViewController") as! StatisticsPageViewController
        // Do all work to put StatisticsPageViewController object into container
        self.addViewControllerTo(container: statisticsPageVC)
        // Set Page View Controller as a delegate of this class
        self.delegate = statisticsPageVC
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Added for debugging purpose
    deinit {
        log.verbose("")
        if (self.refFuelTypes != nil) && (self.observerHandle > 0) {
            // remove observer
            self.refFuelTypes!.removeObserver(withHandle: self.observerHandle)
            log.verbose("Observer for node \(FirebaseNode.fuelType.rawValue) removed")
        }
    }
    
    // MARK: - Actions

    
    // MARK: - Methods
    
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
        // Make child VC aware about parrent
        uiViewController.didMove(toParentViewController: self)
    }
    
}
