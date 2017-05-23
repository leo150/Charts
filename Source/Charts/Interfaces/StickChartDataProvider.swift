//
//  StickChartDataProvider.swift
//  ChartsBugDemo
//
//  Created by Лев Соколов on 10/01/2017.
//  Copyright © 2017 TestName. All rights reserved.
//

import Foundation
import CoreGraphics

@objc
public protocol StickChartDataProvider: BarLineScatterCandleBubbleChartDataProvider
{
	var stickData: StickChartData? { get }
}
