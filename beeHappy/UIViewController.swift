//
//  UIViewController.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 01/07/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

import UIKit

extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
}
