//
//  StatisticsViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit



protocol StatisticsViewControllerDelegate {
    
    func selected(segment : UISegmentedControl)
}

class StatisticsViewController: UIViewController {
    
    
    // MARK: - constants

    
    // MARK: - properties
    @IBOutlet weak var timeRangesSegments: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    
    // delegate
    var delegate : StatisticsViewControllerDelegate?
    
    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        log.verbose("entered")


        // initiate segments with localized names
        for range in iterateEnum(TimeRanges.self) {
            
            self.timeRangesSegments.setTitle(range.rawValue.localized(withDefaultValue: ""),
                                             forSegmentAt: range.hashValue)
        }
        
        // Remark: I could instantiate VC in container using storyboard features ("embed" segue) 
        //         and then set delegate in prepare:forSegue method
        //         This way is to show it can be done programmatically, as well
        
        // Instantiate StatisticsPageViewController
        let statisticsPageVC = UIStoryboard(name: "Statistics", bundle: nil).instantiateViewController(withIdentifier: "StatisticsPageViewController") as! StatisticsPageViewController
        // Do all work to put StatisticsPageViewController object into container
        self.addViewControllerTo(container: statisticsPageVC)
        // Set Page View Controller as a delegate of this class
        self.delegate = statisticsPageVC
        self.delegate?.selected(segment: timeRangesSegments)
    
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
    @IBAction func timeRangesSegmentsChanged(_ sender: UISegmentedControl) {
        
        log.verbose("selected index: \(sender.selectedSegmentIndex)")
        delegate?.selected(segment: sender)
    }
    
    // MARK: - Methods
    
    //! Adding given View Controller to container view programmatically
    func addViewControllerTo(container uiViewController : UIViewController) {
        log.verbose("entered")
        // Tell ViewController to start managing uiViewController
        self.addChildViewController(uiViewController)
        // Set the size of given VC the same as container
        // Note that container is stretched in storyboard through the contraints
        uiViewController.view.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width,
                                             height: self.containerView.frame.size.height)
        // Add View of given VC as a subview of container
        self.containerView.addSubview(uiViewController.view)
        // Make child VC aware about parrent
        uiViewController.didMove(toParentViewController: self)
    }
    
}
