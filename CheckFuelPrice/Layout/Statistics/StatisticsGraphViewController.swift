//
//  StatisticsGraphViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import Charts

class StatisticsGraphViewController: UIViewController, StatisticsGenericProtocol, ChartViewDelegate {

    // MARK: - constants
    var type: FuelName? {
        
        didSet {
            log.verbose("\(type?.rawValue ?? "")")
        }
    }
    var fuelData: [FuelPriceItem]?  {
        
        didSet {
            log.verbose("# of data \(fuelData?.count ?? 0)")
            
            var dateList : [String] = []
            var priceList : [Double] = []
            
            for item in fuelData! {
                dateList.append(item.humanReadableDate)
                priceList.append(item.price)
            }
            
            self.setChart(dataPoints: dateList, values: priceList)
        }
    }
    
    // MARK: - properties

    @IBOutlet var barChartView: BarChartView!

    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        log.verbose("entered")
        self.barChartView.noDataText = "downloadingData".localized(withDefaultValue: "")
        
    }
    
    
    // Added for debugging purpose
    deinit {
        log.verbose("")
    }

    
    // MARK: - Methods
    func setChart(dataPoints: [String], values: [Double]) {

        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "currentFuelPrice".localized(withDefaultValue: ""))
        let chartData = BarChartData(dataSets: [chartDataSet])
        barChartView.data = chartData
        
        
    }
}
