//
// Created by Wojciech Stejka
// Copyright (c) 2017 Wojciech Stejka. All rights reserved.
//

import Foundation
import UIKit

class FuelPricesView: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeader: UIView!
    
    @IBOutlet weak var lowestPriceHeaderDescription: UILabel!
    @IBOutlet weak var highestPriceHeaderDescription: UILabel!

    var presenter: FuelPricesPresenterProtocol?
    var items : [FuelTypeViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        lowestPriceHeaderDescription.text = presenter?.lowestPriceDescription
        highestPriceHeaderDescription.text = presenter?.highestPriceDescription
        navigationItem.title = presenter?.viewTitle
        
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.viewDidDisappear()
    }
    
    deinit {
        log.verbose("The memory successfully deallocated")
    }
}

extension FuelPricesView : FuelPricesViewProtocol {

    func reloadTable(with items: [FuelTypeViewModel]) {
        self.items = items
        tableView.reloadData()
    }
    
    func insertFuelType(_ fuelType: FuelTypeViewModel, atRow: Int) {
        
        items.insert(fuelType, at: atRow)
        let indexPath = IndexPath(row: atRow, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .right)
        tableView.endUpdates()
    }
}


// MARK: - Extension: UITableViewDataSource
extension FuelPricesView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FuelPricesTableViewCell else {
            log.error("Cannot instantiate cell")
            fatalError()
        }
        let fuel = items[indexPath.row]
        
        cell.fuelName.text = fuel.fuelName
        cell.perDateLabel.text = fuel.perDateLabel
        cell.lowestPricesValue.text = fuel.currentLowestPrice
        cell.highestPriceValue.text = fuel.currentHighestPrice
        
        presenter?.configure(cell.fuelUIView, forItem: fuel)
        
        return cell
    }
}

// MARK: - Extension: UITableViewDelegate
extension FuelPricesView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        log.verbose("")
        presenter?.didSelectRowAt(indexPath)
    }
}





