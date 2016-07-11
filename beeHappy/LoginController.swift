//
//  LoginController.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 21/06/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

import UIKit
import SCLAlertView

class LoginController: UIViewController {
	
	@IBOutlet weak var usernameInput: UITextField!
	@IBOutlet weak var passwordInput: UITextField!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var resetPasswordButton: UIButton!
	
	var window : UIWindow?
	let app : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	var api : API?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor(patternImage:UIImage(named: "background")!)
		self.api = app.APIClass!
		
		self.submitButton.backgroundColor = UIColor.clearColor()
		self.submitButton.layer.cornerRadius = 10
		self.submitButton.layer.borderWidth = 1
		self.submitButton.layer.borderColor = UIColor.whiteColor().CGColor
		
		self.resetPasswordButton.backgroundColor = UIColor.clearColor()
		self.resetPasswordButton.layer.cornerRadius = 10
		self.resetPasswordButton.layer.borderWidth = 1
		self.resetPasswordButton.layer.borderColor = UIColor.redColor().CGColor
		
		self.hideKeyboardWhenTappedAround()
	}
	
	@IBAction func resetPasswordButton(sender: UIButton) {
		let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
		let txt = alert.addTextField("Nom d'utilisateur")
		alert.addButton("Envoyer", action: {
			self.api!.resetPassword(txt.text!) { response, error in
				if error == nil {
					let statusCode = response!.response!.statusCode
					switch(statusCode) {
					case 204:
						SCLAlertView().showSuccess("Vérifiez votre boite mail", subTitle: "Nous venons de vous envoyer un mail pour réinitialiser votre mot de passe. \n Veuillez suivre les insctructions contenue dans le mail")
						break;
					case 404:
						SCLAlertView().showError("Nom d'utilisateur inconnu", subTitle: "Le nom d'utilisateur saisi est inconnu. \nMerci de vérifier votre saisie")
						break;
					case 409:
						SCLAlertView().showError("Réinitialisation déjà envoyé", subTitle: "Le mail de réinitialisation à déjà été envoyé au cours de ces 24 dernières heures. Vérifiez votre boite email.\n Merci ")
						break;
						
					default:
						break;
					}
				}
			}
		})
		alert.showEdit("Mot de passe oublié", subTitle: "Veuillez saisir votre nom d'utilisateur afin de réinitialiser votre mot de passe")
	}
	
	@IBAction func clickConnectionButton(sender: UIButton) {
		// Todo : Display loader during api call
		view.endEditing(true)
		
		if  usernameInput.text != nil &&
			passwordInput.text != nil &&
			usernameInput.text != ""  &&
			passwordInput.text != "" {
			
			let username : String = usernameInput.text!
			let password : String = passwordInput.text!
			let connectingWaitAlertViewResponder: SCLAlertViewResponder = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false)).showNotice("Connexion en cours", subTitle: "Connexion en cours ... \n Merci de patienter")
			
			self.api!.auth(username, password: password) { response, error in
				if error == nil {
					let statusCode = response!.response!.statusCode
					let userPref = NSUserDefaults.standardUserDefaults()
					connectingWaitAlertViewResponder.close() // Close waiting connection alert
					
					switch (statusCode) {
					case 200:
						if let JSON = response!.result.value {
							let token = JSON["token"] as! String
							let refreshToken = JSON["refresh_token"] as! String
							userPref.setObject(token, forKey: "token")
							userPref.setObject(refreshToken, forKey: "refreshToken")
							self.api!.token = token
							self.api!.refreshToken = refreshToken
							
							let storyboard = UIStoryboard(name: "Main", bundle: nil)
							let initialViewController = storyboard.instantiateViewControllerWithIdentifier("homepageNC")
							self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
							self.window?.rootViewController = initialViewController
							self.window?.makeKeyAndVisible()
						}
						break;
					case 401:
						SCLAlertView().showInfo(
							"Unknown user",
							subTitle: "Username / password are incorrect",
							closeButtonTitle: "Retry"
						)
						break;
					default:
						break;
					}
				}
			}
		} else {
			SCLAlertView().showError( "Error",
			                          subTitle: "Please complete all fields",
			                          closeButtonTitle: "Retry")
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}
