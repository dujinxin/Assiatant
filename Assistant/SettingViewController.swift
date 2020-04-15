//
//  SettingViewController.swift
//  Assistant
//
//  Created by 飞亦 on 3/14/20.
//  Copyright © 2020 COB. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId1 = "cellId1"
private let cellId2 = "cellId2"

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var titles = ["训练开始提示", "休息", "倒数计时提示", "训练动作提示", "训练结束提示", "提示训练暂停", "训练完成提示", "提示循环完成", "热身提升", "结尾放松提示"]
    
    var languages = [
        ["language": "zh-CN","text": "汉语"],
        ["language": "en-US", "text": "英语"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib.init(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: cellId1)
        self.tableView.register(UINib.init(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: cellId2)
        //self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView.sectionFooterHeight = 0.1
        self.tableView.tableFooterView = UIView()//group类型，设置高度不起作用
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50*kPercent
    }
    
    @IBAction func setting(gender: UIButton) {
        print(1234)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId1, for: indexPath) as! CommonCell
            
            self.languages.forEach { (dict) in
                if let language = dict["language"], let text = dict["text"], language == UserManager.shareInstance.userModel.language {
                    cell.selectLabel.text = text
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! SettingCell
            
            cell.titleLabel.text = titles[indexPath.row - 1]
            cell.switch.tag = indexPath.row
            
            switch indexPath.row {
            case 1:
                cell.switch.isOn = UserManager.shareInstance.userModel.trainStartNotice
            case 2:
                cell.switch.isOn = UserManager.shareInstance.userModel.trainRestNotice
            case 3:
                cell.switch.isOn = UserManager.shareInstance.userModel.countdownNotice
            case 4:
                cell.switch.isOn = UserManager.shareInstance.userModel.trainActionNotice
            case 5:
                cell.switch.isOn = UserManager.shareInstance.userModel.trainStopNotice
            case 6:
                cell.switch.isOn = UserManager.shareInstance.userModel.trainPauseNotice
            case 7:
                cell.switch.isOn = UserManager.shareInstance.userModel.trainFinishNotice
            case 8:
                cell.switch.isOn = UserManager.shareInstance.userModel.trainCycleFinishNotice
            case 9:
                cell.switch.isOn = UserManager.shareInstance.userModel.beginTrainNotice
            case 10:
                cell.switch.isOn = UserManager.shareInstance.userModel.endTrainNotice
            default:
                cell.switch.isOn = true
            }
            return cell
            
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "language") as! LanguageViewController
            vc.language = UserManager.shareInstance.userModel.language
            vc.languages = self.languages
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
