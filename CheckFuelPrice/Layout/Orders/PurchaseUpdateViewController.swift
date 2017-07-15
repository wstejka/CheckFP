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

extension PurchaseUpdateViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPickerItems[row].getLocalizedText()
    }

}

extension PurchaseUpdateViewController : UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        log.verbose("Currently picked: \(dataPickerItems[row].getLocalizedText() ?? "")")
    }
}


class PurchaseUpdateViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var leftButtonItem: UIBarButtonItem!
    @IBOutlet weak var rightButtonItem: UIBarButtonItem!
    

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var actionTextLabel: UILabel!

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: - Vars/Consts
    public let delegate : PurchaseUpdateViewControllerDelegate? = nil
    
    var snapshot : FuelPurchase? = nil
    
    let dataPickerItems : [Fuel] = {
       
        var items : [Fuel] = []
        for fuelType in iterateEnum(Fuel.self) {
            if fuelType == .none {
                continue
            }
            items.append(fuelType)
        }
        
        return items
    }()
    
    // MARK: - UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if snapshot == nil {
            actionTextLabel.text = "addNewPurchase".localized()
            snapshot = FuelPurchase()
            snapshot?.fuelType = Fuel.unleaded95.rawValue
        }
        else {
            actionTextLabel.text = "editExistingPurchase".localized()
        }
        guard let fuelPurchase = snapshot else { return }
        
        // set up current values
        pickerView.selectRow(fuelPurchase.fuelType - 1, inComponent: 0, animated: true)
        datePicker.setDate(Date(timeIntervalSince1970: Double(fuelPurchase.timestamp)), animated: true)
        
        amountLabel.text = "amount".localized()
        amountTextField.text = fuelPurchase.amount.strRound(to: 2)
        
        priceLabel.text = "price".localized()
        priceTextField.text = fuelPurchase.price.strRound(to: 2)
        
        // set up numeric keyboard to simplify providing data
        amountTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        priceTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        log.verbose("")
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        log.verbose("")
        AppUtility.lockOrientation([.portrait,.landscapeLeft,.landscapeRight])
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.portrait
    }

    // MARK: - Actions
    
    @IBAction func leftButtonItemPressed(_ sender: UIBarButtonItem) {
        log.verbose("")
        dismiss(animated: true, completion: nil)
    }

    @IBAction func rightButtonItemPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        log.verbose("\(sender.date)")
    }
    
    
}
