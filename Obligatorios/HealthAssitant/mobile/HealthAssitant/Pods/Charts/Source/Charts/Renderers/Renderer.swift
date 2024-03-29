//
//  Renderer.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import CoreGraphics
import Foundation

@objc(ChartRenderer)
public protocol Renderer {
    /// the component that handles the drawing area of the chart and it's offsets
    var viewPortHandler: ViewPortHandler { get }
}
