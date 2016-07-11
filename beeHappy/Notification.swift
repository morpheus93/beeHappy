//
//  Notification.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 30/06/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//
import UIKit

class Notification {
	var send_at            : String?
	var hive_coordinate    : NSDictionary?
	var hive_description   : String?
	var hive_name          : String?
	var hive_slug          : String?
	
	var alert_threshold    : Int?
	var alert_comparison   : Int?
	var alert_description  : String?
	var alert_message      : String?
	
	var type_name          : String?
	var type_slug          : String?
	var type_description   : String?
	
	var alert_slug		   : String?
	var alert_name		   : String?
	
	init(send_at : String, hive_coordinate : NSDictionary, hive_description : String, hive_name : String, hive_slug : String, alert_threshold : Int, alert_comparison : Int, alert_description : String, alert_message : String, type_name : String, type_slug : String, type_description : String, alert_name : String, alert_slug : String) {
		
		self.send_at             = send_at
		self.hive_coordinate     = hive_coordinate
		self.hive_description    = hive_description
		self.hive_name           = hive_name
		self.hive_slug           = hive_slug
		self.alert_threshold     = alert_threshold
		self.alert_comparison    = alert_comparison
		self.alert_description   = alert_description
		self.alert_message       = alert_message
		self.type_name           = type_name
		self.type_slug           = type_slug
		self.type_description    = type_description
		self.alert_slug			 = alert_slug
		self.alert_name			 = alert_name
	}
}