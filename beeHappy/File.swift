//
//  File.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 28/06/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FileHelper {
	
	func downloadFile(filename : String) {
		let url : String = "\(API().getBaseFileUrl())/\(filename)"
		Alamofire.request(.GET, url)
			.responseImage { response in
				if let image = response.result.value {
					self.persistImageToDisk(image)
				}
		}
	}
	
	func persistImageToDisk(image : UIImage) -> Bool {
		if let data = UIImagePNGRepresentation(image) {
			let filename = self.getDocumentsDirectory().stringByAppendingPathComponent("profilePicture.png")
			data.writeToFile(filename, atomically: true)
		}
		return true
	}
	
	func getDocumentsDirectory() -> NSString {
		let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}
}