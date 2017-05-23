//
//  IStickChartDataSet.swift
//  ChartsBugDemo
//
//  Created by Лев Соколов on 10/01/2017.
//  Copyright © 2017 TestName. All rights reserved.
//

import Foundation
import CoreGraphics

@objc
public protocol IStickChartDataSet: ILineScatterCandleRadarChartDataSet
{
	// MARK: - Data functions and accessors
	
	// MARK: - Styling functions and accessors
	
	/// the space that is left out on the left and right side of each stick,
	/// **default**: 0.1 (10%), max 0.45, min 0.0
	var barSpace: CGFloat { get set }
	
	var circleHoleSpace: CGFloat { get set }
	
	/// color of circles on stick ends
	var circleHoleColor: NSUIColor? { get set }
	
	/// fill color of circles on stick ends
	var circleColor: NSUIColor? { get set }
	
	/// fill color of each stick
	var stickColor: NSUIColor? { get set }
}
