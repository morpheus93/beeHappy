//
//  AlertDetailController.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 01/07/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

import UIKit

class AlertDetailController: UIViewController {
	
	@IBOutlet weak var alertNameText: UILabel!
	@IBOutlet weak var messageText: UITextView!
	@IBOutlet weak var descriptionText: UITextView!
	@IBOutlet weak var comparisonText: UILabel!
	@IBOutlet weak var sensorText: UILabel!
	@IBOutlet weak var thresholdText: UILabel!
	
	let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	var api : API?
	var alert : Alert!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.api = app.APIClass!
		self.alertNameText.text = self.alert.name
		self.messageText.text = self.alert.message
		self.descriptionText.text = self.alert.description
		self.comparisonText.text = self.getComparisonText(self.alert.comparison)
		self.sensorText.text = self.alert.type_name
		self.thresholdText.text = "\(self.alert.threshold!)"
	}
	
	private func getComparisonText(value : Int!) -> String{
		var message : String = ""
		
		switch value {
		case 1:
			message = "égal à"
			break
		case 2:
			message = "pas égal à"
			break
		case 3:
			message = "inférieur à"
			break
		case 4:
			message = "supérieur à"
			break
		case 5:
			message = "inférieur ou égal à"
			break
		case 6:
			message = "supérieur ou égal à"
			break
		default:
			message = ""
			break
		}
		return message
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
}

