//
//  StickChartDataEntry.swift
//  ChartsBugDemo
//
//  Created by Лев Соколов on 10/01/2017.
//  Copyright © 2017 TestName. All rights reserved.
//

import Foundation

open class StickChartDataEntry: ChartDataEntry
{
	/// shadow-high value
	open var high = Double(0.0)
	
	/// shadow-low value
	open var low = Double(0.0)
	
	public required init()
	{
		super.init()
	}
	
	public init(x: Double, high: Double, low: Double)
	{
		super.init(x: x, y: (high + low) / 2.0)
		
		self.high = high
		self.low = low
	}
	
	public init(x: Double, high: Double, low: Double, data: AnyObject?)
	{
		super.init(x: x, y: (high + low) / 2.0, data: data)
		
		self.high = high
		self.low = low
	}
	
	/// - returns: The overall range (difference) between high and low.
	open var bodyRange: Double
	{
		return abs(high - low)
	}
	
	/// the center value of the stick. (Middle value between high and low)
	open override var y: Double
	{
		get
		{
			return super.y
		}
		set
		{
			super.y = (high + low) / 2.0
		}
	}
	
	// MARK: NSCopying
	
	open override func copyWithZone(_ zone: NSZone?) -> AnyObject
	{
		let copy = super.copyWithZone(zone) as! StickChartDataEntry
		copy.high = high
		copy.low = low
		return copy
	}
}
