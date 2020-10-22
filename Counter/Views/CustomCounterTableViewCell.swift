//
//  CustomTableViewCell.swift
//  Counter
//
//  Created by Артем  Емельянов  on 02/11/2019.
//  Copyright © 2019 Artem Emelianov. All rights reserved.
//

import UIKit

class CustomCounterTableViewCell: UITableViewCell {
    
    var plusButtonToched: (() -> Void)?
    var minusButtonToched: (() -> Void)?
    
    @IBOutlet var countLabel: UILabel!
	
    @IBAction func plusButton(_ sender: Any) {
		self.plusButtonToched?()
    }
	
    @IBAction func minusButton(_ sender: Any) {
		self.minusButtonToched?()
    }
}
