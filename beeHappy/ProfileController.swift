//
//  ProfileController.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 27/06/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView

class ProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	var api : API?
	var alerts = [Alert]()
	let userPref = NSUserDefaults.standardUserDefaults()
	
	@IBOutlet weak var profilePicture: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var alertListTableView: UITableView!
	
	@IBAction func editPasswordButton(sender: AnyObject) {
		
		let appearance = SCLAlertView.SCLAppearance(
			showCircularIcon: true,
			showCloseButton: false
		)
		let alert = SCLAlertView(appearance: appearance)
		let password = alert.addTextField("Nouveau mot de passe")
		let confirmation = alert.addTextField("Confirmation de mot de passe")
		alert.addButton("Valider", backgroundColor: UIColor(red: 0, green: 1, blue: 0, alpha: 1)) {
			let password : String = password.text!
			let confirmation : String = confirmation.text!
			if password != "" || confirmation != "" {
				if password == confirmation {
					let params : [String : AnyObject] = ["plainPassword" : password]
					self.api!.editUser(params) { response, error in
						if error == nil {
							let statusCode = response?.response?.statusCode
							let JSON = response?.result.value
							
							switch (statusCode!){
							case 200:
								SCLAlertView().showSuccess("Succès", subTitle: "Le mot de passe à bien été modifié !")
								break;
							case 400:
								var message : String = "Oups, une erreur est survenue ..."
								if let form_error = JSON!["form_error"] as? String{
									message += "\n \(form_error)"
								}
								SCLAlertView().showError("Erreur", subTitle: message)
								break;
							default:
								SCLAlertView().showError("Erreur", subTitle: "Oups, une erreur est survenue ...")
								break;
							}
						}
					}
				} else {
					SCLAlertView().showError("Mots de passe différents", subTitle: "Attention, vos mots de passe sont différents.\nMerci de vérifier votre saisie")
				}
			}
		}
		alert.addButton("Fermer"){}
		
		alert.showEdit("Modification du compte", subTitle: "Modification du mot de passe")
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.api = self.app.APIClass!
		usernameLabel.text = userPref.stringForKey("username")
		emailLabel.text = userPref.stringForKey("email")
		let profilePictureFilename = FileHelper().getDocumentsDirectory().stringByAppendingPathComponent("profilePicture.png")
		self.profilePicture.image = UIImage(contentsOfFile: profilePictureFilename)
		
		self.api!.getAlerts { response, error in
			if error == nil {
				let JSON = response?.result.value
				let alerts = JSON!["alerts"] as! NSArray
				for alert in alerts {
					let obj = alert as! NSDictionary
					let type = obj["type"] as! NSDictionary
					let tmpAlert = Alert(threshold: obj["threshold"] as! Int, comparison: obj["comparison"] as! Int, description: obj["description"] as! String, message: obj["message"] as! String, name: obj["message"] as! String, slug: obj["slug"] as! String, type_name: type["name"] as! String, type_slug: type["slug"] as! String, type_description: type["description"] as! String)
					
					self.alerts.append(tmpAlert)
				}
				self.alertListTableView.reloadData()
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return self.alerts.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = self.alertListTableView.dequeueReusableCellWithIdentifier("alertCell")! as UITableViewCell
		let alert: Alert = self.alerts[indexPath.row]
		
		cell.textLabel?.text = alert.name
		cell.detailTextLabel?.text = alert.description
		return cell
	}
	
	//MARK: Segue
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if  segue.identifier == "showAlertDetailSegue",
			let DetailsVC = segue.destinationViewController as? AlertDetailController,
			let index = self.alertListTableView.indexPathForSelectedRow?.row
		{
			let alert = self.alerts[index]
			DetailsVC.alert = alert
			DetailsVC.api = self.api
		}
	}
	
}