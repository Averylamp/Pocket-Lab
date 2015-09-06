//
//  PatientInfoTableViewCell.swift
//  Draculapp
//
//  Created by Jake Spracher on 9/6/15.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

import UIKit

class PatientInfoTableViewCell: UITableViewCell {

    @IBOutlet var label: UILabel!
    @IBOutlet var info: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
