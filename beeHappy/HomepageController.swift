//
//  HomepageController.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 23/06/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

import UIKit
import SCLAlertView

class HomepageController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	
	@IBOutlet weak var alertListView: UITableView!
	
	var api : API?
	let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	var notificationsList = [Notification]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.alertListView.backgroundView = UIImageView(image: UIImage())
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		self.api = app.APIClass!
		self.api!.getNotifications { response, error in
			if error == nil {
				let JSON = response?.result.value
				let notifications = JSON!["notifications"] as! NSArray
				for notification in notifications {
					let obj = notification as! NSDictionary
					let hive = obj["hive"] as! NSDictionary
					let alert = obj["alert"] as! NSDictionary
					let type = alert["type"] as! NSDictionary
					
					let tmpNotif = Notification(
						send_at : obj["send_at"] as! String,
						hive_coordinate : hive["coordinate"] as! NSDictionary,
						hive_description : hive["description"] as! String,
						hive_name : hive["name"] as! String,
						hive_slug : hive["slug"] as! String,
						alert_threshold : alert["threshold"] as! Int,
						alert_comparison : alert["threshold"] as! Int,
						alert_description : alert["description"] as! String,
						alert_message : alert["message"] as! String,
						type_name : type["name"] as! String,
						type_slug : type["slug"] as! String,
						type_description : type["description"] as! String,
						alert_name : alert["name"] as! String,
						alert_slug  : alert["slug"] as! String
					)
					self.notificationsList.append(tmpNotif)
				}
				self.alertListView.reloadData()
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			}
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - TableView
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		let count = self.notificationsList.count
		
		/*if  count == 0 {
		let backgroundView = UINib(nibName: "LoadingView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
		tableView.backgroundView = backgroundView
		} else {
		tableView.backgroundView = nil
		}*/
		
		return count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell")! as! HPAlertCustomCell
		
		var notification: Notification
		
		notification = self.notificationsList[indexPath.row]
		cell.alertMessage?.text = notification.alert_message
		cell.alertDate?.text = notification.send_at
		cell.alertType?.text = notification.type_name
		return cell
	}
	
	
}

