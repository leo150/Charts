//
//  StickChartDataSet.swift
//  ChartsBugDemo
//
//  Created by Лев Соколов on 10/01/2017.
//  Copyright © 2017 TestName. All rights reserved.
//

import Foundation
import CoreGraphics

open class StickChartDataSet: LineScatterCandleRadarChartDataSet, IStickChartDataSet
{
	public required init()
	{
		super.init()
	}
	
	public override init(values: [ChartDataEntry]?, label: String?)
	{
		super.init(values: values, label: label)
	}
	
	// MARK: - Data functions and accessors
	
	open override func calcMinMax(entry e: ChartDataEntry)
	{
		guard let e = e as? StickChartDataEntry
			else { return }
		
		if e.low < _yMin
		{
			_yMin = e.low
		}
		
		if e.high > _yMax
		{
			_yMax = e.high
		}
		
		calcMinMaxX(entry: e)
	}
	
	// MARK: - Styling functions and accessors
	
	/// the space between the stick entries
	///
	/// **default**: 0.1 (10%)
	fileprivate var _barSpace = CGFloat(0.1)
	
	/// the space that is left out on the left and right side of each stick,
	/// **default**: 0.1 (10%), max 0.45, min 0.0
	open var barSpace: CGFloat
	{
		set
		{
			if newValue < 0.0
			{
				_barSpace = 0.0
			}
			else if newValue > 0.45
			{
				_barSpace = 0.45
			}
			else
			{
				_barSpace = newValue
			}
		}
		get
		{
			return _barSpace
		}
	}
	
	///
	/// **default**: 0.5
	open var circleHoleSpace: CGFloat = CGFloat(0.5)
	
	/// color of circles on stick ends
	open var circleHoleColor: NSUIColor?
	
	/// fill color of circles on stick ends
	open var circleColor: NSUIColor?
	
	/// fill color of each stick
	open var stickColor: NSUIColor?
}
