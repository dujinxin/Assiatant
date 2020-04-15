//
//  CommonCell.swift
//  Assistant
//
//  Created by 飞亦 on 3/14/20.
//  Copyright © 2020 COB. All rights reserved.
//

import UIKit

class CommonCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
