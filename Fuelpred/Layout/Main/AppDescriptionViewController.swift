//
//  AppDescriptionViewController.swift
//  Fuelpred
//
//  Created by Wojciech Stejka on 03/08/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class AppDescriptionViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerLabel.text = "firstStartupHeader".localized()
        descriptionTextView.text = "firstStartupDescription".localized()
    }

    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
