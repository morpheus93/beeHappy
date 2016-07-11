//
//  UIImageExtension.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 30/06/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

import UIKit

extension UIImage{
	
	func alpha(value:CGFloat)->UIImage
	{
		UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
		
		let ctx = UIGraphicsGetCurrentContext();
		let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
		
		CGContextScaleCTM(ctx, 1, -1);
		CGContextTranslateCTM(ctx, 0, -area.size.height);
		//CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
		CGContextSetAlpha(ctx, value);
		CGContextDrawImage(ctx, area, self.CGImage);
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		return newImage;
	}
}