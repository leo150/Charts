//
//  StickChartRenderer.swift
//  ChartsBugDemo
//
//  Created by Лев Соколов on 10/01/2017.
//  Copyright © 2017 TestName. All rights reserved.
//

import Foundation
import CoreGraphics

#if !os(OSX)
	import UIKit
#endif

open class StickChartRenderer: LineScatterCandleRadarRenderer
{
	open weak var dataProvider: StickChartDataProvider?
	
	public init(dataProvider: StickChartDataProvider?, animator: Animator?, viewPortHandler: ViewPortHandler?)
	{
		super.init(animator: animator, viewPortHandler: viewPortHandler)
		
		self.dataProvider = dataProvider
	}
	
	open override func drawData(context: CGContext)
	{
		guard let dataProvider = dataProvider, let stickData = dataProvider.stickData else { return }
		
		for set in stickData.dataSets as! [IStickChartDataSet]
		{
			if set.isVisible
			{
				drawDataSet(context: context, dataSet: set)
			}
		}
	}
	
	fileprivate var _rangePoints = [CGPoint](repeating: CGPoint(), count: 2)
	fileprivate var _bodyRect = CGRect()
	fileprivate var _lineSegments = [CGPoint](repeating: CGPoint(), count: 2)
	
	open func drawDataSet(context: CGContext, dataSet: IStickChartDataSet)
	{
		guard let
			dataProvider = dataProvider,
			let animator = animator
			else { return }
		
		let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
		
		let phaseY = animator.phaseY
		let barSpace = dataSet.barSpace
		
		_xBounds.set(chart: dataProvider, dataSet: dataSet, animator: animator)
		
		context.saveGState()
		
//		context.setLineWidth(dataSet.shadowWidth)
		
		for j in stride(from: _xBounds.min, through: _xBounds.range + _xBounds.min, by: 1)
		{
			// get the entry
			guard let e = dataSet.entryForIndex(j) as? StickChartDataEntry else { continue }
			
			let xPos = e.x
			
			let high = e.high
			let low = e.low
			
			// calculate the body
			
			_bodyRect.origin.x = CGFloat(xPos) - 0.5 + barSpace
			_bodyRect.origin.y = CGFloat(low * phaseY)
			_bodyRect.size.width = (CGFloat(xPos) + 0.5 - barSpace) - _bodyRect.origin.x
			_bodyRect.size.height = CGFloat(high * phaseY) - _bodyRect.origin.y
			
			trans.rectValueToPixel(&_bodyRect)
			
			// draw body differently for increasing and decreasing entry
			
			let color = dataSet.stickColor ?? dataSet.color(atIndex: j)
			
			_bodyRect.origin.y += _bodyRect.size.width / 2
			_bodyRect.size.height -= _bodyRect.size.width
			
			context.setFillColor(color.cgColor)
			context.fill(_bodyRect)
			
			if let circleColor = dataSet.circleColor {
				context.setFillColor(circleColor.cgColor)
				
				var rect = CGRect()
				rect.origin.x = _bodyRect.origin.x
				rect.origin.y = _bodyRect.origin.y - _bodyRect.size.width + _bodyRect.size.width / 2
				rect.size.width = _bodyRect.size.width
				rect.size.height = _bodyRect.size.width
				context.fillEllipse(in: rect)

				rect.origin.x = _bodyRect.origin.x
				rect.origin.y = _bodyRect.origin.y + _bodyRect.size.height - _bodyRect.size.width / 2
				rect.size.width = _bodyRect.size.width
				rect.size.height = _bodyRect.size.width
				context.fillEllipse(in: rect)
				
				
			}
		}
		
		context.restoreGState()
	}
	
	open override func drawValues(context: CGContext)
	{
		guard
			let dataProvider = dataProvider,
			let viewPortHandler = self.viewPortHandler,
			let stickData = dataProvider.stickData,
			let animator = animator
			else { return }
		
		// if values are drawn
		if isDrawingValuesAllowed(dataProvider: dataProvider)
		{
			var dataSets = stickData.dataSets
			
			let phaseY = animator.phaseY
			
			var pt = CGPoint()
			
			for i in 0 ..< dataSets.count
			{
				guard let dataSet = dataSets[i] as? IBarLineScatterCandleBubbleChartDataSet
					else { continue }
				
				if !shouldDrawValues(forDataSet: dataSet)
				{
					continue
				}
				
				let valueFont = dataSet.valueFont
				
				guard let formatter = dataSet.valueFormatter else { continue }
				
				let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
				let valueToPixelMatrix = trans.valueToPixelMatrix
				
				_xBounds.set(chart: dataProvider, dataSet: dataSet, animator: animator)
				
				let lineHeight = valueFont.lineHeight
				let yOffset: CGFloat = lineHeight + 5.0
				
				for j in stride(from: _xBounds.min, through: _xBounds.range + _xBounds.min, by: 1)
				{
					guard let e = dataSet.entryForIndex(j) as? StickChartDataEntry else { break }
					
					pt.x = CGFloat(e.x)
					pt.y = CGFloat(e.high * phaseY)
					pt = pt.applying(valueToPixelMatrix)
					
					if (!viewPortHandler.isInBoundsRight(pt.x))
					{
						break
					}
					
					if (!viewPortHandler.isInBoundsLeft(pt.x) || !viewPortHandler.isInBoundsY(pt.y))
					{
						continue
					}
					
					ChartUtils.drawText(
						context: context,
						text: formatter.stringForValue(
							e.high,
							entry: e,
							dataSetIndex: i,
							viewPortHandler: viewPortHandler),
						point: CGPoint(
							x: pt.x,
							y: pt.y - yOffset),
						align: .center,
						attributes: [NSFontAttributeName: valueFont, NSForegroundColorAttributeName: dataSet.valueTextColorAt(j)])
				}
			}
		}
	}
	
	open override func drawExtras(context: CGContext)
	{
	}
	
	open override func drawHighlighted(context: CGContext, indices: [Highlight])
	{
		guard
			let dataProvider = dataProvider,
			let stickData = dataProvider.stickData,
			let animator = animator
			else { return }
		
		context.saveGState()
		
		for high in indices
		{
			guard
				let set = stickData.getDataSetByIndex(high.dataSetIndex) as? IStickChartDataSet,
				set.isHighlightEnabled
				else { continue }
			
			guard let e = set.entryForXValue(high.x, closestToY: high.y) as? StickChartDataEntry else { continue }
			
			if !isInBoundsX(entry: e, dataSet: set)
			{
				continue
			}
			
			let trans = dataProvider.getTransformer(forAxis: set.axisDependency)
			
			context.setStrokeColor(set.highlightColor.cgColor)
			context.setLineWidth(set.highlightLineWidth)
			
			if set.highlightLineDashLengths != nil
			{
				context.setLineDash(phase: set.highlightLineDashPhase, lengths: set.highlightLineDashLengths!)
			}
			else
			{
				context.setLineDash(phase: 0.0, lengths: [])
			}
			
			let lowValue = e.low * Double(animator.phaseY)
			let highValue = e.high * Double(animator.phaseY)
			let y = (lowValue + highValue) / 2.0
			
			let pt = trans.pixelForValues(x: e.x, y: y)
			
			high.setDraw(pt: pt)
			
			// draw the lines
			drawHighlightLines(context: context, point: pt, set: set)
		}
		
		context.restoreGState()
	}
}
