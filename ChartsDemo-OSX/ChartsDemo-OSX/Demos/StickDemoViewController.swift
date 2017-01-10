//
//  StickDemoViewController.swift
//  ChartsDemo-OSX
//
//  Created by Лев Соколов on 10/01/2017.
//  Copyright © 2017 dcg. All rights reserved.
//

import Foundation
import Cocoa
import Charts

open class StickDemoViewController: NSViewController
{
	@IBOutlet var stickChartView: StickChartView!
	
	override open func viewDidLoad()
	{
		super.viewDidLoad()
		
		let chartData = StickChartData()
		
		var yve = [StickChartDataEntry]()
		
		for x in 1...30 {
			let high = Double(arc4random_uniform(100) + 80)
			let low = high - Double(arc4random_uniform(40)) - 10.0
			yve.append(StickChartDataEntry(x: Double(x), high: high, low: low))
		}
		
		let set1 = StickChartDataSet(values: yve, label: "text")
		set1.stickColor = NSUIColor.red
		set1.circleColor = NSUIColor.green
		
		chartData.addDataSet(set1)
		
		stickChartView.data = chartData
		stickChartView.gridBackgroundColor = NSUIColor.white
		stickChartView.chartDescription?.text = "Chart Description"
		
		let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
		paragraphStyle.lineBreakMode = .byTruncatingTail
		paragraphStyle.alignment = .center
		let centerText: NSMutableAttributedString = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
		centerText.setAttributes([NSFontAttributeName: NSFont(name: "HelveticaNeue-Light", size: 15.0)!, NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, centerText.length))
		centerText.addAttributes([NSFontAttributeName: NSFont(name: "HelveticaNeue-Light", size: 13.0)!, NSForegroundColorAttributeName: NSColor.gray], range: NSMakeRange(10, centerText.length - 10))
		centerText.addAttributes([NSFontAttributeName: NSFont(name: "HelveticaNeue-LightItalic", size: 13.0)!, NSForegroundColorAttributeName: NSColor(red: 51 / 255.0, green: 181 / 255.0, blue: 229 / 255.0, alpha: 1.0)], range: NSMakeRange(centerText.length - 19, 19))
	}
	
	override open func viewWillAppear()
	{
		self.stickChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
	}
}
