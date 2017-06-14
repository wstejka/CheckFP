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

extension StatisticsPageViewController : StatisticsViewControllerDelegate {
    func selectedFuel(type: FuelName) {
        log.verbose("entered")
        
        // notifify all children about change
        for viewController in self.orderedViewControllers {
            
            var controller = viewController as? StatisticsGenericProtocol
            controller?.type = type
        }
    }

    
}


class StatisticsPageViewController: UIPageViewController {


    // MARK: - constants
    let postfix = "StatViewController"
    let storyboardName = "Statistics"
    
    lazy var orderedViewControllers: [UIViewController] = {
        
        log.verbose("entered")
        return [self.StatisticsPageViewControllerWith(sufix: "Graph"),
                self.StatisticsPageViewControllerWith(sufix: "Table")]
    }()
    
    private func StatisticsPageViewControllerWith(sufix: String) -> UIViewController {
        
        let viewControllerIdentity = "\(sufix)\(postfix)"
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: viewControllerIdentity)
    }
    
    
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

}
