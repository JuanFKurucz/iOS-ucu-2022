//
//  ChartsViewController.swift
//  HealthAssitant
//
//  Created by Juan Francisco Kurucz on 16/6/22.
//

import UIKit
import Charts

struct GraphData {
    let index: Int
    let label: String
    let value: Double
    
    func transformToBarChartDataEntry() -> BarChartDataEntry {
        let entry = BarChartDataEntry(x: Double(index), y: value)
        return entry
    }
}



// Custom value formatter class
class BarValueFormatter : NSObject, ValueFormatter {

    // This method is  called when a value (from labels inside the chart) is formatted before being drawn.
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        let digitWithoutFractionValues = String(format: "%.0f", value)
        return digitWithoutFractionValues
    }

}

class ChartsViewController: UIViewController, ChartViewDelegate {
    static let identifier : String = "ChartsViewController"
    @IBOutlet weak var chartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //chart data
        let items = [
            GraphData(index: 0, label: "Australia", value: 1.83),
            GraphData(index: 1, label: "Belgium", value: 2.54),
            GraphData(index: 2, label: "Germany", value: 3.32),
            GraphData(index: 3, label: "Japan", value: 4.23)
        ]
        // Do any additional setup after loading the view.
        let dataEntries = items.map{ $0.transformToBarChartDataEntry() }
        
        let set1 = BarChartDataSet(entries: dataEntries)
        set1.setColor(.green)
        set1.highlightColor = .blue
        set1.highlightAlpha = 1
        
        let data = BarChartData(dataSet: set1)
        data.setDrawValues(true)
        data.setValueTextColor(.black)
        
        let barValueFormatter = BarValueFormatter()
        data.setValueFormatter(barValueFormatter as! ValueFormatter)
        
        chartView.data = data
        
        // chart style
        
        chartView.delegate = self
        
        // Hightlight
        chartView.highlightPerTapEnabled = true
        chartView.highlightFullBarEnabled = true
        chartView.highlightPerDragEnabled = false
        
        // disable zoom function
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(false)
        chartView.doubleTapToZoomEnabled = false

        // Bar, Grid Line, Background
        chartView.drawBarShadowEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.borderColor = .black
        
        // Legend
        chartView.legend.enabled = false
        
        // Chart Offset
        chartView.setExtraOffsets(left: 10, top: 0, right: 20, bottom: 50)
        
        // Animation
        chartView.animate(yAxisDuration: 1.5 , easingOption: .easeOutBounce)

        // Setup X axis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.granularityEnabled = false
        xAxis.labelRotationAngle = -25
        xAxis.setLabelCount(items.count, force: false)
        xAxis.valueFormatter = IndexAxisValueFormatter(values: items.map { $0.label })
        xAxis.axisMaximum = Double(items.count)
        xAxis.axisLineColor = .black
        xAxis.labelTextColor = .black

        // Setup left axis
        let leftAxis = chartView.leftAxis
        leftAxis.drawTopYLabelEntryEnabled = true
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = false
        leftAxis.axisLineColor = .black
        leftAxis.labelTextColor = .black

        leftAxis.setLabelCount(6, force: true)
        leftAxis.axisMinimum = 0.0
        leftAxis.axisMaximum = 2.5

        // Remove right axis
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
    }
}
