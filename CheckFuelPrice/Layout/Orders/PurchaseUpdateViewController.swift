//
//  PurchaseUpdateViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 15/07/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit

protocol PurchaseUpdateViewControllerDelegate {
    
    func savedPurchase(snapshot: FuelPurchase)
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
    @IBOutlet weak var amountTextField: WSUITextField!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTextField: WSUITextField!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: - Vars/Consts
    public var delegate : PurchaseUpdateViewControllerDelegate? = nil
    
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
        
        let value = fuelPurchase.amount * fuelPurchase.price
        valueLabel.text = value.strRound(to: 2)
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

    // MARK: - Methods
    func computeValueLabel() {
        
        
        let amount = Float(amountTextField.getValue())
        let price = Float(priceTextField.getValue())
        
        let value = amount! * price!
        valueLabel.text = value.strRound(to: 2)
    }

    
    // MARK: - Actions
    
    @IBAction func leftButtonItemPressed(_ sender: UIBarButtonItem) {
        log.verbose("")
        dismiss(animated: true, completion: nil)
    }

    @IBAction func rightButtonItemPressed(_ sender: UIBarButtonItem) {

        var value = amountTextField.text!
        self.snapshot?.amount = Double(value)!
        value = priceTextField.text!
        self.snapshot?.price = Double(value)!
        self.snapshot?.timestamp = datePicker.date.getSimpleTimestamp()
        self.snapshot?.humanReadableDate = datePicker.date.toString()
        self.snapshot?.fuelType = pickerView.selectedRow(inComponent: 0) + 1
        delegate?.savedPurchase(snapshot: self.snapshot!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        log.verbose("\(sender.date)")
    }
    
    @IBAction func amountEditingDidEnd(_ sender: UITextField) {
        log.verbose("")
        computeValueLabel()
    }
    
    @IBAction func priceEditingDidEnd(_ sender: UITextField) {
        log.verbose("")
        computeValueLabel()
    }
    
}
