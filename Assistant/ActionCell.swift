//
//  ActionCell.swift
//  Assistant
//
//  Created by 飞亦 on 3/13/20.
//  Copyright © 2020 COB. All rights reserved.
//

import UIKit

class ActionCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
