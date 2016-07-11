//
//  HiveListeController.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 26/06/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

import UIKit

class HiveListController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
	
	let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	var api : API?
	
	@IBOutlet weak var hiveTableView: UITableView!
	
	var hiveList = [Hive]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.hiveTableView.backgroundView = UIImageView(image: UIImage())
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		self.api = app.APIClass!
		self.api!.getHiveList { response, error in
			if error == nil {
				let JSON = response?.result.value
				let hives = JSON!["hives"] as! NSArray
				for hive in hives {
					let obj = hive as! NSDictionary
					let tmpHive = Hive(
						name:			obj["name"] as! String,
						slug:			obj["slug"] as! String,
						description :	obj["description"] as! String
					)
					self.hiveList.append(tmpHive)
				}
				self.hiveTableView.reloadData()
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//MARK: Segue
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if  segue.identifier == "showHiveDetailSegue",
			let DetailsVC = segue.destinationViewController as? HiveDetailController,
			let index = self.hiveTableView.indexPathForSelectedRow?.row
		{
			let hive = self.hiveList[index]
			DetailsVC.hive = hive
			DetailsVC.api = self.api
		}
	}
	
	
	//MARK: - TableView
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		let count = self.hiveList.count
		
		return count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = self.hiveTableView.dequeueReusableCellWithIdentifier("hiveCell")! as UITableViewCell
		var hive: Hive
		hive = self.hiveList[indexPath.row]
		
		cell.textLabel?.text = hive.name
		cell.detailTextLabel?.text = hive.description
		return cell
	}
}
