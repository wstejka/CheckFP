//
//  PurchaseUpdateViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 15/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

protocol PurchaseUpdateViewControllerDelegate {
    
    func savedPurchase(snapshot: DataSnapshot)
}

class PurchaseUpdateViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var leftButtonItem: UIBarButtonItem!
    @IBOutlet weak var rightButtonItem: UIBarButtonItem!
    
    // MARK: - Vars/Consts
    public let delegate : PurchaseUpdateViewControllerDelegate? = nil
    
    var snapshot : FuelPurchase? = nil
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Actions
    
    @IBAction func leftButtonItemPressed(_ sender: UIBarButtonItem) {
        log.verbose("")
        dismiss(animated: true, completion: nil)
    }

    @IBAction func rightButtonItemPressed(_ sender: UIBarButtonItem) {
    }
    
}
