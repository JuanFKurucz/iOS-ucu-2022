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
    
    var diagnosticItems : [GraphData] = []
    var symptomsItems : [GraphData] = []
    var symptomsRange : [Int] = []
    var diagnosticRange : [Int] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIHealthAssitant.predictStatistics(onComplete: {stats in
            self.diagnosticItems = []
            self.symptomsItems = []
            var minValue = -1
            var maxValue = -1
            for diag in stats.diagnostics {
                if maxValue == -1 || diag.value > maxValue {
                    maxValue = diag.value
                }
                if minValue == -1 || diag.value < minValue {
                    minValue = diag.value
                }
                let diagnostic = Diagnosis(rawValue: diag.key) ?? Diagnosis.Unknown
                self.diagnosticItems.append(GraphData(index:self.diagnosticItems.count, label: diagnostic.text, value: Double(diag.value)))
            }
            self.diagnosticRange = [minValue,maxValue]
            minValue = -1
            maxValue = -1
            for sym in stats.symptoms {
                if maxValue == -1 || sym.value > maxValue {
                    maxValue = sym.value
                }
                if minValue == -1 || sym.value < minValue {
                    minValue = sym.value
                }
                let symptom = Symptom(rawValue: sym.key) ?? Symptom.Unknown
                self.symptomsItems.append(GraphData(index:self.symptomsItems.count, label: symptom.text, value: Double(sym.value)))
            }
            self.symptomsRange = [minValue,maxValue]
            self.loadGraph(items: self.diagnosticItems,minValue: self.diagnosticRange[0],maxValue: self.diagnosticRange[1])
        }, onFail: {_ in
            Alert.showAlertBox(currentViewController: self, title: "Invalid predict statistics", message: "Could not fetch statistics")
        })
    }
    @IBAction func onDiagnosticGraph(_ sender: Any) {
        self.loadGraph(items: self.diagnosticItems,minValue: self.diagnosticRange[0],maxValue: self.diagnosticRange[1])
    }
    
    @IBAction func onSymptomGraph(_ sender: Any) {
        self.loadGraph(items: self.symptomsItems,minValue: self.symptomsRange[0],maxValue: self.symptomsRange[1])
    }
    
    func loadGraph(items: [GraphData], minValue: Int, maxValue: Int) {
        // Do any additional setup after loading the view.
        let dataEntries = items.map{ $0.transformToBarChartDataEntry() }
        
        let set1 = BarChartDataSet(entries: dataEntries)
        
        var colors:[UIColor] = []
        for _ in 0...items.count {
            colors.append(UIColor(
                red:   CGFloat(Float.random(in: 0..<1)),
                green: CGFloat(Float.random(in: 0..<1)),
                blue:  CGFloat(Float.random(in: 0..<1)),
                alpha: CGFloat(Float.random(in: 0.5..<1))
            ))
        }
        set1.colors = colors
        set1.highlightColor = .blue
        set1.highlightAlpha = 1
        
        let data = BarChartData(dataSet: set1)
        data.setDrawValues(true)
        data.setValueTextColor(.black)
        
        let barValueFormatter = BarValueFormatter()
        data.setValueFormatter(barValueFormatter as ValueFormatter)
        
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
        leftAxis.axisMinimum = Double(minValue)
        leftAxis.axisMaximum = Double(maxValue)

        // Remove right axis
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
