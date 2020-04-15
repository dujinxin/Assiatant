//
//  TrainModel.swift
//  Assistant
//
//  Created by 飞亦 on 3/14/20.
//  Copyright © 2020 COB. All rights reserved.
//

import UIKit
import JXFMDBHelper
import JXFoundation

private let dbName = "TrainDB"

class TrainModel: BaseModel {
    
    @objc var id : Int = 0
    //动作
    @objc var trainActionsStr : String = "" //以>符号拼接
    //总训练时间
    @objc var totalTrainSeconds : Int = 10
    //时间
    @objc var time : String = ""
  
}
class TrainManager: BaseDB {
    
    static let shareInstance = TrainManager(name: dbName)
    
    var trainModel : TrainModel = TrainModel()

    override init(name: String) {
        super.init(name: name)
    }
    /// 保存用户数据
    ///
    /// - Parameter data: 用户数据
    /// - Returns: 返回结果
    func saveUserInfo(data: Dictionary<String, Any>) -> Bool {
        if let dataArray = self.selectData(),
            dataArray.isEmpty == false {
            let isSuccess = self.updateData(keyValues: data)
            if isSuccess {
                trainModel.setValuesForKeys(data)
            }
            return isSuccess
        } else {
            let isSuccess = self.insertData(data: data)
            if isSuccess {
                trainModel.setValuesForKeys(data)
            }
            return isSuccess
        }
    }
    func updateUserInfo() {
        
        let dict = ["trainActionsStr": trainModel.trainActionsStr,
        "singleTrainMinutes": trainModel.totalTrainSeconds,
        "time": trainModel.time] as [String : Any]
        
        
        let _ = self.createTable(keys: Array(dict.keys))
        if let dataArray = self.selectData(), dataArray.isEmpty == true, self.insertData(data: dict) {
            trainModel.setValuesForKeys(dict)
        } else {
            if self.updateData(keyValues: dict) == true {
                trainModel.setValuesForKeys(dict)
            }
        }
    }
}
