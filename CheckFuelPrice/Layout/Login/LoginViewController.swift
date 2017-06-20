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
        loginTestField.placeholder = "loginPlaceholder".localized().localizedCapitalized
        passwordTextField.placeholder = "passwordPlaceholder".localized().localizedCapitalized
        loginButton.setTitle("login".localized().capitalizingFirstLetter(), for: UIControlState.normal)
        singUpButton.setTitle("signUp".localized().capitalizingFirstLetter(), for: UIControlState.normal)
        
    }
    

    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        log.verbose("entered: \(segue.identifier ?? "")")
        
    }

    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        log.verbose("entered")
    }
    
    //  MARK: Actions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        log.verbose("entered")
        performSegue(withIdentifier: goToMainViewSegue, sender: nil)

    }
    
    @IBAction func singUpButtonPressed(_ sender: Any) {
        log.verbose("entered")
    }


}
