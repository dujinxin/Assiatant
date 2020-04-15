//
//  RecordsCell.swift
//  Assistant
//
//  Created by 飞亦 on 3/16/20.
//  Copyright © 2020 COB. All rights reserved.
//

import UIKit

class RecordsCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.layer.cornerRadius = 20
            backView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    
    
    var entity: TrainModel? {
        didSet {
            let s = String(entity?.time.suffix(8) ?? "")
            let ss = String(s.prefix(5))
            timeLabel.text = ss
            totalLabel.text = "\((entity?.totalTrainSeconds ?? 0) / 60)"
            actionLabel.text = entity?.trainActionsStr
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
