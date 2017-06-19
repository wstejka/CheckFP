//
//  LoginViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 19/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Constans/variables
    let goToMainViewSegue = "GoToMainViewSegue"
    
    
    // MARK: - Properties
    
    @IBOutlet weak var headingLable: UILabel!
    @IBOutlet weak var loginTestField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var singUpButton: UIButton!

    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        log.verbose("entered")
        loginTestField.placeholder = "login".localized().localizedCapitalized
        passwordTextField.placeholder = "password".localized().localizedCapitalized
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        log.verbose("entered: \(segue.identifier ?? "")")
        
    }

    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        
    }
    
    //  MARK: Actions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        log.verbose("entered")
        performSegue(withIdentifier: goToMainViewSegue, sender: nil)

    }
    
    @IBOutlet weak var passwordButtonPressed: UIButton!


}
