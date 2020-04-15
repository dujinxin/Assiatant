//
//  SettingCell.swift
//  Assistant
//
//  Created by 飞亦 on 3/14/20.
//  Copyright © 2020 COB. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBAction func settingSwitch(_ sender: UISwitch) {
        
        switch sender.tag {
        case 1:
            UserManager.shareInstance.userModel.trainStartNotice = sender.isOn
        case 2:
             UserManager.shareInstance.userModel.trainRestNotice = sender.isOn
        case 3:
            UserManager.shareInstance.userModel.countdownNotice = sender.isOn
        case 4:
            UserManager.shareInstance.userModel.trainActionNotice = sender.isOn
        case 5:
            UserManager.shareInstance.userModel.trainStopNotice = sender.isOn
        case 6:
            UserManager.shareInstance.userModel.trainPauseNotice = sender.isOn
        case 7:
            UserManager.shareInstance.userModel.trainFinishNotice = sender.isOn
        case 8:
            UserManager.shareInstance.userModel.trainCycleFinishNotice = sender.isOn
        case 9:
            UserManager.shareInstance.userModel.beginTrainNotice = sender.isOn
        case 10:
            UserManager.shareInstance.userModel.endTrainNotice = sender.isOn
        default:
            print(sender.isOn)
        }
        
        UserManager.shareInstance.updateUserInfo()
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
