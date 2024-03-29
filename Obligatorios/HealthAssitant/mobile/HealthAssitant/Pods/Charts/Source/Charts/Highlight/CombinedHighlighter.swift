//
//  CombinedHighlighter.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Algorithms
import CoreGraphics
import Foundation

@objc(CombinedChartHighlighter)
open class CombinedHighlighter: ChartHighlighter {
    /// bar highlighter for supporting stacked highlighting
    private var barHighlighter: BarHighlighter?

    @objc public init(chart: CombinedChartDataProvider, barDataProvider: BarChartDataProvider) {
        super.init(chart: chart)

        // if there is BarData, create a BarHighlighter
        barHighlighter = barDataProvider.barData == nil ? nil : BarHighlighter(chart: barDataProvider)
    }

    override open func getHighlights(xValue: Double, x: CGFloat, y: CGFloat) -> [Highlight] {
        var vals = [Highlight]()

        guard
            let chart = chart as? CombinedChartDataProvider,
            let dataObjects = chart.combinedData?.allData
        else { return vals }

        for (i, dataObject) in dataObjects.indexed() {
            // in case of BarData, let the BarHighlighter take over
            if barHighlighter != nil, dataObject is BarChartData,
               let high = barHighlighter?.getHighlight(x: x, y: y)
            {
                high.dataIndex = i
                vals.append(high)
            } else {
                for (j, set) in dataObject.indexed() where set.isHighlightEnabled {
                    let highs = buildHighlights(dataSet: set, dataSetIndex: j, xValue: xValue, rounding: .closest)

                    for high in highs {
                        high.dataIndex = i
                        vals.append(high)
                    }
                }
            }
        }

        return vals
    }
}
