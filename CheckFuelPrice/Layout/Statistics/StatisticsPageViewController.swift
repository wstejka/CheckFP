//
//  StatisticsPageViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 03/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

// Let's create generic to force existence of segment value
protocol StatisticsGenericProtocol {
    
    var type: FuelName? { get set }
    var fuelData : [FuelPriceItem]? { get set}
}

// MARK: - UIPageViewController lifecycle
extension StatisticsPageViewController : UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // get current viewcontroller index
        guard let currentIndex = self.orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        // decrement currentIndex to get index of previous ViewController
        let previousIndex = currentIndex - 1
        // validate if index is positive value
        guard previousIndex >= 0 else {
            return self.orderedViewControllers.last
        }
        // validate index is still in values' range
        guard previousIndex < self.orderedViewControllers.count else {
            return nil
        }
        
        return self.orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // get current viewcontroller index
        guard let currentIndex = self.orderedViewControllers.index(of: viewController) else {
            return nil
        }
        // increment currentIndex to get index of previous ViewController
        let nextIndex = currentIndex + 1
        
        // validate index is still in values' range
        guard nextIndex < self.orderedViewControllers.count else {
            return self.orderedViewControllers.first
        }
        
        return self.orderedViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

// MARK: - StatisticsViewControllerDelegate
extension StatisticsPageViewController : StatisticsViewControllerDelegate {
    
    
    func selectedFuel(name type: FuelName) {
        log.verbose("entered")
        if self.type == type {
            log.verbose("fuel type didn't change. Ingoring ...")
            return
        }
        self.type = type
        self.requestData(for: type)
    }

    
}


class StatisticsPageViewController: UIPageViewController {


    // MARK: - constants
    let postfix = "StatViewController"
    let storyboardName = "Statistics"
    var type = FuelName.none
    
    lazy var orderedViewControllers: [UIViewController] = {
        
        log.verbose("entered")
        return [self.StatisticsPageViewControllerWith(sufix: "Graph"),
                self.StatisticsPageViewControllerWith(sufix: "Table")]
    }()
    
    var items : [FuelPriceItem] = []
    var refFuelPriceItems : DatabaseReference? = nil
    var observerHandle : DatabaseHandle = 0
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    // MARK: - properties
    
    
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        log.verbose("entered")
        self.dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        // Change page colors as they are by default white the same as background color
        let pageControlAppearance = UIPageControl.appearance(whenContainedInInstancesOf: [StatisticsPageViewController.self])
        pageControlAppearance.pageIndicatorTintColor = UIColor.lightGray
        pageControlAppearance.currentPageIndicatorTintColor = UIColor.black
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Added for debugging purpose
    deinit {
        log.verbose("")
    }
    
    // MARK: - Methods
    func requestData(for type: FuelName) {
        
        // Configure reference to firebase node
        self.refFuelPriceItems = Database.database().reference(withPath: FirebaseNode.fuelPriceItem.rawValue)
        Utils.customActivityIndicatory(self.view, startAnimate: true)
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            // Calculate current epoch timestamp
            let timestamp = Int(Date().timeIntervalSince1970)
            let lastMonthTimestamp = timestamp - (60 * 60 * 24 * 30)
            
            // to avoid retain cycle let's pass weak reference to self
            let keyPrefix = String(describing: Producer.lotos.hashValue) + "_" + String(describing: type.hashValue)
            let startingKey = keyPrefix + "_" + String(describing: lastMonthTimestamp)
            let endingKey = keyPrefix + "_" + String(describing: timestamp)
            
            log.verbose("range keys \(startingKey) - \(endingKey)")
            
            // request using key: producent/fuel type/timestamp
            self.refFuelPriceItems!.queryOrdered(byChild: "P_FT_T").queryStarting(atValue: startingKey).queryEnding(atValue: endingKey).observeSingleEvent(of: .value, with: { [weak self] snapshot in
                
                guard let selfweak = self else {
                    return
                }
                // accept only last request. All previous ones ignore ...
                if selfweak.type != type {
                    log.error("There is newest request on the list. The \"\(type)\" will be ignored.")
                    return
                }

                log.verbose("Observe: \(selfweak.refFuelPriceItems!.description()) \(snapshot.childrenCount)")
                var newItems: [FuelPriceItem] = []
                for item in snapshot.children {
                    guard let fuelPriceItem = FuelPriceItem(snapshot: item as! DataSnapshot) else {
                        log.verbose("Cannot parse data")
                        continue
                    }
                    newItems.append(fuelPriceItem)
                }

                // Run this command on main queue as it affects UI
                DispatchQueue.main.async {
                    Utils.customActivityIndicatory(selfweak.view, startAnimate: false)
                }
                selfweak.items = newItems
                selfweak.notifyAllChildrenAboutChange(type: type)
                
            })
        }
    }
    
    
    private func StatisticsPageViewControllerWith(sufix: String) -> UIViewController {
        
        let viewControllerIdentity = "\(sufix)\(postfix)"
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: viewControllerIdentity)
    }

    func notifyAllChildrenAboutChange(type: FuelName) {
        // notify all children about change
        for viewController in self.orderedViewControllers {
            
            var controller = viewController as? StatisticsGenericProtocol
            controller?.fuelData = self.items
        }
    }

    // MARK : - Activity indicator lifecycle
    
    /* Note there is no needed to use below code as here is used the Utils.customActivityIndicatory
    func startActivityIndicator() {
        
        self.activityIndicator.center = self.view.center
        self.activityIndicator.frame = CGRect(x:0.0,y: 0.0,width: 200.0, height: 200.0)
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        
    }
    */
}
