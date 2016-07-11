//
//  HiveDetailController.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 26/06/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

import UIKit
import Charts

class HiveDetailController: UIViewController {
	
	var hive : Hive!
	var api : API!
	
	@IBOutlet weak var hiveNameLabel: UILabel!
	@IBOutlet weak var insideTemperatureLabel: UILabel!
	@IBOutlet weak var insideTemperatureView: LineChartView!
	
	@IBOutlet weak var outsideTemperatureLabel: UILabel!
	@IBOutlet weak var outsideTemperatureView: LineChartView!
	
	@IBOutlet weak var outsideAirQualityLabel: UILabel!
	@IBOutlet weak var outsideAirQualityView: LineChartView!
	
	@IBOutlet weak var insideHumisityLabel: UILabel!
	@IBOutlet weak var insideHumisityView: LineChartView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.api.getHiveDetail(self.hive.slug!) { response, error in
			if error == nil {
				if let JSON = response?.result.value{
					let hive = JSON["hive"] as! NSDictionary
					self.hive.api_key = hive["api_key"] as? String
				}
			}
		}
		self.hiveNameLabel.text				= hive.name
		self.insideHumisityLabel.text		= "Humidité intérieur"
		self.insideTemperatureLabel.text	= "Température intérieur"
		self.outsideTemperatureLabel.text	= "Température extérieur"
		self.outsideAirQualityLabel.text	= "Qualité de l'air extérieur"
		
		self.getHiveDatas("temperature-inside", view : insideTemperatureView, label: "°C")
		self.getHiveDatas("temperature-outside", view : outsideTemperatureView, label: "°C")
		self.getHiveDatas("air-quality-outside", view : outsideAirQualityView, label: "%")
		self.getHiveDatas("humidity-inside", view : insideHumisityView, label: "%")
	}
	
	override func viewWillAppear(animated: Bool) {
		insideTemperatureView.animate(xAxisDuration: 1.0)
		insideHumisityView.animate(xAxisDuration: 1.0)
		outsideTemperatureView.animate(xAxisDuration: 1.0)
		outsideAirQualityView.animate(xAxisDuration: 1.0)
	}
	
	func getHiveDatas(measureSlug: String, view : LineChartView, label : String) {
		self.api.getHiveMeasures(self.hive.slug!, measureSlug: measureSlug) { response, error in
			if error == nil {
				var xAxis = [Double]()
				var yAxis = [String]()
				let JSON = response?.result.value
				let measures = JSON!["measures"] as! NSArray
				for measure in measures {
					let obj = measure as! NSDictionary
					let created_at = obj["created_at"] as! String
					xAxis.append(obj["value"] as! Double)
					
					yAxis.append(self.convertDateTimeToDateString(created_at))
				}
				self.setChart(yAxis.reverse(), values: xAxis.reverse(), view: view, label: label)
			}
		}
	}
	
	func setChart(dataPoints: [String], values: [Double], view: LineChartView, label : String) {
		
		var dataEntries: [ChartDataEntry] = []
		
		for i in 0..<dataPoints.count {
			let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
			dataEntries.append(dataEntry)
		}
		
		let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: label)
		let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
		view.data = lineChartData
		view.descriptionTextColor = NSUIColor(white: 1, alpha: 1)
		view.descriptionText = ""
	}
	
	private func convertDateTimeToDateString(date : String) -> String{
		let dateFormatter = NSDateFormatter()
		dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR")
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let nsdate = dateFormatter.dateFromString(date)
		dateFormatter.dateFormat = "dd-MM HH:mm:ss"
		return "\(dateFormatter.stringFromDate(nsdate!))"
	}
}
