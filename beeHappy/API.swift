//
//  API.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 21/06/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

import Foundation
import Alamofire

class API {
	
	var token : String = ""
	var refreshToken : String = ""
	private var apiUrl : String = "https://bee-happy.labesse.me" // TODO : remove
	private var urlList: NSDictionary = [:]
	
	/**
	Constructor
	
	- returns: void
	*/
	init() {
		// TODO : Get token & refreshToken from NSUserDefaults
		self.urlList = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("UrlsList", ofType: "plist")!)!
		let userPref = NSUserDefaults.standardUserDefaults()
		let storedToken = userPref.stringForKey("token")
		let storedRefreshToken = userPref.stringForKey("refreshToken")
		
		if  nil != storedToken && nil != storedRefreshToken {
			self.token = storedToken!
			self.refreshToken = storedRefreshToken!
		}
		
		if nil != userPref.stringForKey("api_url") {
			apiUrl = userPref.stringForKey("api_url")!
		}
	}
	
	func getBaseFileUrl() -> String {
		return self.apiUrl
	}
	
	// MARK: - Public calls
	
	/**
	Make user authentification call
	
	- parameter username: username
	- parameter password: password
	*/
	func auth (username : String, password : String, completionHandler: (Response<AnyObject, NSError>?, NSError?) -> ()) {
		let link = urlList["getToken"]!
		let params = ["username": username, "password": password]
		self.makePostCall(link as! String, params: params, completionHandler: completionHandler)
	}
	
	/**
	Make user authentification call
	
	- parameter username: username
	*/
	func resetPassword (username : String, completionHandler: (Response<AnyObject, NSError>?, NSError?) -> ()) {
		let link = urlList["resetPassword"]!
		let params = ["username": username]
		self.makePostCall(link as! String, params: params, completionHandler: completionHandler)
	}
	
	/**
	Get current user informations
	*/
	func getUserInfos (completionHandler: (Response<AnyObject, NSError>?, NSError?) -> ()) {
		let link = urlList["getMe"]!
		makeAuthGetCall(link as! String, params: [], completionHandler: completionHandler)	
	}
	
	/**
	Get user hives
	*/
	func getHiveList (completionHandler: (Response<AnyObject, NSError>?, NSError?) -> ()) {
		let link = urlList["getHives"]!
		makeAuthGetCall(link as! String, params: [], completionHandler: completionHandler)
	}
	
	/**
	Get alerts
	*/
	func getAlerts(completionHandler: (Response<AnyObject, NSError>?, NSError?) -> ()) {
		let link = urlList["getAlerts"]!
		makeAuthGetCall(link as! String, params: [], completionHandler: completionHandler)
	}
	
	/**
	Get alert with slug
	*/
	func getAlert(slug : String, completionHandler: (Response<AnyObject, NSError>?, NSError?) -> ()) {
		let link = "\(urlList["getAlerts"]!)/\(slug)"
		makeAuthGetCall(link , params: [], completionHandler: completionHandler)
	}
	
	/**
	Find a hive with his slug and get details
	
	- parameter hiveSlug:   Slug of an hive
	*/
	func getHiveDetail (hiveSlug : String, completionHandler: (Response<AnyObject, NSError>?, NSError?) -> ()) {
		let link = "\(urlList["getHiveDetail"]!)\(hiveSlug)"
		makeAuthGetCall(link, params: [], completionHandler: completionHandler)
	}
	
	/**
	Get measures for a hive
	
	- parameter hiveSlug:          Hive slug
	- parameter measureSlug:       Measure slug
	*/
	func getHiveMeasures(hiveSlug : String, measureSlug : String, completionHandler : (Response<AnyObject, NSError>?, NSError?) ->()){
		let link = "\(urlList["getHiveDetail"]!)\(hiveSlug)\(urlList["getMeasures"]!)\(measureSlug)"
		makeAuthGetCall(link, params: [], completionHandler: completionHandler)
	}
	
	/**
	Get notifications for an account
	*/
	func getNotifications(completionHandler : (Response<AnyObject, NSError>?, NSError?) ->()){
		let link = "\(urlList["getNotifications"]!)?order=DESC&order_by=sendAt"
		makeAuthGetCall(link, params: [], completionHandler: completionHandler)
	}
	
	func editUser(params : [String : AnyObject], completionHandler : (Response<AnyObject, NSError>?, NSError?) ->()) {
		let link = "\(urlList["getMe"]!)"
		makeAuthPostCall(link, params: params, completionHandler: completionHandler)
	}
	
	
	// MARK: - Generic call method
	
	// MARK: Authenticated calls
	
	/**
	Make api call with method POST
	
	- parameter url:    server URL
	- parameter params: post params
	
	- returns: Response Json
	*/
	private func makeAuthGetCall (link : String, params : NSObject, completionHandler: (Response<AnyObject, NSError>?, NSError?) -> ()) {
		
		let url = "\(self.apiUrl)\(link)"
		let headers = [
			"Authorization": "Bearer \(self.token)",
			"Accept": "application/json"
		]
		Alamofire
			.request(.GET, url, encoding: .JSON, headers: headers)
			.responseJSON {
				(response: Response<AnyObject, NSError>) in
				completionHandler(response, nil)
		}
	}
	
	/**
	Make api call with method POST & Header authenticated
	
	- parameter url:    server URL
	- parameter params: post params
	
	- returns: Response Json
	*/
	private func makeAuthPostCall (link : String, params : NSObject, completionHandler: (Response<AnyObject, NSError>?, NSError?) -> ()) {
		let url = "\(apiUrl)\(link)"
		let headers = [
			"Authorization": "Bearer \(self.token)",
			"Accept": "application/json"
		]
		
		Alamofire
			.request(.POST, url, parameters: params as? [String : AnyObject], headers: headers)
			.responseJSON {
				(response: Response<AnyObject, NSError>) in
				completionHandler(response, nil)
		}
	}
	
	// MARK: Unregistred calls
	
	/**
	Make api call with method POST
	
	- parameter url:    server URL
	- parameter params: post params
	
	- returns: Response Json
	*/
	private func makePostCall (link : String, params : NSObject, completionHandler: (Response<AnyObject, NSError>?, NSError?) -> ()) {
		let url = "\(apiUrl)\(link)"
		Alamofire
			.request(.POST, url, parameters: params as? [String : AnyObject])
			.responseJSON {
				(response: Response<AnyObject, NSError>) in
				completionHandler(response, nil)
		}
	}
	
	/**
	Make api call with method POST
	
	- parameter url:    server URL
	- parameter params: post params
	
	- returns: Response Json
	*/
	private func makeGetCall (url : String, params : NSObject, completionHandler: (Response<AnyObject, NSError>?, NSError?) -> ()) {
		Alamofire
			.request(.GET, url, parameters: params as? [String : AnyObject])
			.responseJSON {
				(response: Response<AnyObject, NSError>) in
				completionHandler(response, nil)
		}
	}
}
