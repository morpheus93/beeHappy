//
//  MenuController.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 23/06/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

import UIKit

class MenuController: UIViewController {
	
	var window: UIWindow?
	let userPref = NSUserDefaults.standardUserDefaults()
	var api : API?
	let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	
	@IBOutlet weak var profilePicture: UIImageView!
	@IBOutlet weak var userNameLabel: UILabel!
	
	@IBAction func disconnectButton(sender: UIButton) {
		
		userPref.removeObjectForKey("username")
		userPref.removeObjectForKey("email")
		userPref.removeObjectForKey("token")
		userPref.removeObjectForKey("refreshToken")
		self.api?.token = ""
		self.api?.refreshToken = ""
		
		self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let initialViewController = storyboard.instantiateViewControllerWithIdentifier("loginView")
		self.window?.rootViewController = initialViewController
		self.window?.makeKeyAndVisible()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.api = self.app.APIClass
		let profilePictureFilename = FileHelper().getDocumentsDirectory().stringByAppendingPathComponent("profilePicture.png")
		self.profilePicture.image = UIImage(contentsOfFile: profilePictureFilename)
		self.userNameLabel.text = userPref.stringForKey("username")
		
		UINavigationBar.appearance().setBackgroundImage(UIImage(named: "backgroundHeader"), forBarMetrics: .Default)
		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().translucent = false
		UIApplication.sharedApplication().statusBarStyle = .LightContent
		UITabBar.appearance().backgroundImage = UIImage(named: "backgroundHeader")
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
}
