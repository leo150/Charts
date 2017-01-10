//
//  StickChartView.swift
//  ChartsBugDemo
//
//  Created by Лев Соколов on 10/01/2017.
//  Copyright © 2017 TestName. All rights reserved.
//

import Foundation
import CoreGraphics

/// Financial chart type that draws stick-sticks.
open class StickChartView: BarLineChartViewBase, StickChartDataProvider
{
	open override func initialize() //to internal
	{
		super.initialize()
		
		renderer = StickChartRenderer(dataProvider: self, animator: _animator, viewPortHandler: _viewPortHandler)
		
		self.xAxis.spaceMin = 0.5
		self.xAxis.spaceMax = 0.5
	}
	
	// MARK: - CandleChartDataProvider
	
	open var stickData: StickChartData?
	{
		return _data as? StickChartData
	}
}
