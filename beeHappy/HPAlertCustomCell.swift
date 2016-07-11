//
//  HPAlertCustomCell.swift
//  beeHappy
//
//  Created by Laouiti Elias Cédric on 30/06/2016.
//  Copyright © 2016 Laouiti Elias Cédric. All rights reserved.
//

import UIKit

class HPAlertCustomCell: UITableViewCell {
	
	@IBOutlet weak var alertMessage: UILabel!
	@IBOutlet weak var alertType: UILabel!
	@IBOutlet weak var alertDate: UILabel!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		// Configure the view for the selected state
	}
	
}
