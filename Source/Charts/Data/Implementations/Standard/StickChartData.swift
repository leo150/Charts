//
//  StickChartData.swift
//  ChartsBugDemo
//
//  Created by Лев Соколов on 10/01/2017.
//  Copyright © 2017 TestName. All rights reserved.
//

import Foundation

open class StickChartData: BarLineScatterCandleBubbleChartData
{
	public override init()
	{
		super.init()
	}
	
	public override init(dataSets: [IChartDataSet]?)
	{
		super.init(dataSets: dataSets)
	}
}
