//
//  StatisticsGraphViewController.swift
//  CheckFuelPrice
//
//  Created by Wojciech Stejka on 12/06/2017.
//  Copyright © 2017 Wojciech Stejka. All rights reserved.
//

import UIKit
import Charts
import Chameleon

class StatisticsGraphViewController: UIViewController, StatisticsGenericProtocol, ChartViewDelegate {

    // MARK: - constants
    var type: FuelName? {
        
        didSet {
            log.verbose("\(type?.rawValue ?? "")")
        }
    }
    
    var dateList : [String] = []
    var priceList : [Double] = []
    var fuelData: [FuelPriceItem]?  {
        
        didSet {
            log.verbose("# of data \(fuelData?.count ?? 0)")
            dateList = []
            priceList = []
            for item in fuelData! {
                self.dateList.append(item.humanReadableDate)
                self.priceList.append(item.price)
            }
            
            self.setChart(dataPoints: self.dateList, values: self.priceList)
        }
    }
    
    var currentOrientation : UIInterfaceOrientation! = nil
    var chartXAxisLabelCounterDivider = 6
    
    // MARK: - properties

    @IBOutlet weak var barChartView: BarChartView!

    
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

    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if (toInterfaceOrientation.isLandscape) {
            self.chartXAxisLabelCounterDivider = 3
        }
        else {
            self.chartXAxisLabelCounterDivider = 6
        }
        self.barChartView.xAxis.setLabelCount(Int(self.dateList.count / self.chartXAxisLabelCounterDivider), force: true)
    }
    
    // MARK: - Methods
    func setChart(dataPoints: [String], values: [Double]) {

        log.debug("entered")
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "fuelPrice".localized(withDefaultValue: ""))
        chartDataSet.colors = [.skyCrayonColor]
        let chartData = BarChartData(dataSets: [chartDataSet])
        // Don't let resize chart
        barChartView.doubleTapToZoomEnabled = false
        barChartView.data = chartData
        
        barChartView.chartDescription?.text = ""
        
        // present xAxis description at bottom
        barChartView.xAxis.labelPosition = .bottom
        // Customize xAxis values
        barChartView.xAxis.valueFormatter = XValsFormatter(xVals: dataPoints)
        barChartView.xAxis.setLabelCount(Int(dataPoints.count / self.chartXAxisLabelCounterDivider), force: true)
        // Add animation
        barChartView.animate(xAxisDuration: 1.0, easingOption: ChartEasingOption.easeOutCubic)
    }
    
}

class XValsFormatter: NSObject, IAxisValueFormatter {
    
    let xVals: [String]
    init(xVals: [String]) {
        self.xVals = xVals
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let position = Int(value)
        
        return xVals[position]
    }
    
}
