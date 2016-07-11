//
//  Hive.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 26/06/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

class Hive {
	
	var name            : String?
	var slug			: String?
	var description     : String?
	var api_key			: String?
	
	init(name : String, slug : String, description : String){
		self.name = name
		self.slug = slug
		self.description = description
	}
}