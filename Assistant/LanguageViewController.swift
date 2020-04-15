//
//  LanguageViewController.swift
//  Assistant
//
//  Created by 飞亦 on 3/17/20.
//  Copyright © 2020 COB. All rights reserved.
//

import UIKit
import JXFoundation

private let cellId = "cellId"

class LanguageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var languages = Array<Dictionary<String, String>>()
    var language: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib.init(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: cellId)
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
        return languages.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommonCell
        
        let dict = languages[indexPath.row]
        cell.titleLabel.text = dict["text"]
        
        if let language = dict["language"],  language == UserManager.shareInstance.userModel.language {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dict = languages[indexPath.row]
        UserManager.shareInstance.userModel.language = dict["language"] ?? "zh-CN"
        UserManager.shareInstance.updateUserInfo()
        
        tableView.reloadData()
    }
}
