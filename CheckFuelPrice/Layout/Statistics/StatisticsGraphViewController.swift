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
    var months: [String]!

    
    // MARK: - properties

    @IBOutlet var barChartView: BarChartView!

    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        log.verbose("entered")
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        self.setChart(dataPoints: months, values: unitsSold)
//        self.title = "Line Chart 1";
        

        

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
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Units Sold")
        let chartData = BarChartData(dataSets: [chartDataSet]) //xVals: months, dataSet: chartDataSet)
        barChartView.data = chartData
        
        
    }
}
