//
//  Alert.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 01/07/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

import UIKit

class Alert {
	var threshold			: Int?
	var comparison			: Int?
	var description			: String?
	var message				: String?
	var name				: String?
	var slug				: String?
	
	var type_name			: String?
	var type_slug			: String?
	var type_description	: String?
	
	init(threshold: Int, comparison: Int, description: String, message: String, name: String, slug: String, type_name: String, type_slug: String, type_description: String) {
		
		self.threshold			= threshold
		self.comparison			= comparison
		self.description		= description
		self.message			= message
		self.name				= name
		self.slug				= slug
		self.type_name			= type_name
		self.type_slug			= type_slug
		self.type_description	= type_description
	}
}