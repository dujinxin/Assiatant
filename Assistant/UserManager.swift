//
//  UserManager.swift
//  Assistant
//
//  Created by 飞亦 on 3/14/20.
//  Copyright © 2020 COB. All rights reserved.
//


import UIKit
import JXFMDBHelper
import JXFoundation

private let dbName = "UserDB"


private let userPath = NSHomeDirectory() + "/Documents/userAccound.json"

class UserModel: BaseModel {
  
    @objc var id : Int = 0
    //动作
    @objc var trainActionsStr : String = "" //以&符号拼接
    @objc var trainActions = Array<String>()
    //单次训练时间
    @objc var singleTrainMinutes : Int = 0
    @objc var singleTrainSeconds : Int = 10
    //单次训练间隔时间
    @objc var singleTrainIntervalMinutes : Int = 0
    @objc var singleTrainIntervalSeconds : Int = 15
    //循环次数
    @objc var cycleTrainNum : Int = 2
    //循环间隔
    @objc var cycleIntervalMinutes : Int = 0
    @objc var cycleIntervalSeconds : Int = 20
    //开头热身运动
    @objc var beginTrainMinutes : Int = 0
    @objc var beginTrainSeconds : Int = 30
    //结尾拉伸运动
    @objc var endTrainMinutes : Int = 0
    @objc var endTrainSeconds : Int = 30
    
    //动作库
    @objc var totalTrainActionsStr : String = ""
    @objc var totalTrainActions = Array<String>()
    
    
    //是否使用震动
    @objc var useShock : Bool = true
    //是否使用语音提示
    @objc var useVoice : Bool = true
    
    
    //语言
    @objc var language : String = "zh-CN"
    //训练开始提示
    @objc var trainStartNotice : Bool = true
    //训练结束提示
    @objc var trainStopNotice : Bool = true
    //训练完成提示
    @objc var trainFinishNotice : Bool = true
    //训练暂停提示
    @objc var trainPauseNotice : Bool = true
    //倒计时提示（3，2，1）
    @objc var countdownNotice : Bool = true
    //训练动作提示
    @objc var trainActionNotice : Bool = true
    //休息提示,下个动作提示
    @objc var trainRestNotice : Bool = true
    //下个动作提示
    //@objc var trainNextActionNotice : Bool = true
    //循环完成提示
    @objc var trainCycleFinishNotice : Bool = true
    //热身运动提示
    @objc var beginTrainNotice : Bool = true
    //拉伸运动提示
    @objc var endTrainNotice : Bool = true
    
    
}

class UserManager: BaseDB {

    static let shareInstance = UserManager(name: dbName)
    
    var userModel : UserModel = UserModel()
    var userDict : Dictionary<String, Any> = [:]

    override init(name: String) {
        super.init(name: name)
        setUserInfo()
    }
    /// 用户数据初始化
    func setUserInfo() {
        if self.manager.isExist == false {
            print("table 不存在")
            return
        }
        guard let data = self.selectData(), data.isEmpty == false else {
            print("无配置信息")
            return
        }
            
        userModel.setValuesForKeys(data[0] as! [String : Any])
        if userModel.trainActionsStr.isEmpty == false {
            userModel.trainActions = userModel.trainActionsStr.components(separatedBy: "&")
        }
        if userModel.totalTrainActionsStr.isEmpty == false {
            userModel.totalTrainActions = userModel.totalTrainActionsStr.components(separatedBy: "&")
        }
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
                userModel.setValuesForKeys(data)
                userModel.trainActions = userModel.trainActionsStr.components(separatedBy: "&")
                userModel.totalTrainActions = userModel.totalTrainActionsStr.components(separatedBy: "&")
            }
            return isSuccess
        } else {
            let isSuccess = self.insertData(data: data)
            if isSuccess {
                userModel.setValuesForKeys(data)
                userModel.trainActions = userModel.trainActionsStr.components(separatedBy: "&")
                userModel.totalTrainActions = userModel.totalTrainActionsStr.components(separatedBy: "&")
            }
            return isSuccess
        }
    }
    func updateUserInfo() {
        self.userDict.removeAll(keepingCapacity: true)
        
        let dict = ["trainActionsStr": userModel.trainActionsStr,
        "singleTrainMinutes": userModel.singleTrainMinutes,
        "singleTrainSeconds": userModel.singleTrainSeconds,
        "singleTrainIntervalMinutes": userModel.singleTrainIntervalMinutes,
        "singleTrainIntervalSeconds": userModel.singleTrainIntervalSeconds,
        "cycleTrainNum": userModel.cycleTrainNum,
        "cycleIntervalMinutes": userModel.cycleIntervalMinutes,
        "cycleIntervalSeconds": userModel.cycleIntervalSeconds,
        "beginTrainMinutes": userModel.beginTrainMinutes,
        "beginTrainSeconds": userModel.beginTrainSeconds,
        "endTrainMinutes": userModel.endTrainMinutes,
        "endTrainSeconds": userModel.endTrainSeconds,
        "totalTrainActionsStr": userModel.totalTrainActionsStr,
        
        "useShock": userModel.useShock,
        "useVoice": userModel.useVoice,
            
        "language": userModel.language,
        "trainStartNotice": userModel.trainStartNotice,
        "trainStopNotice": userModel.trainStopNotice,
        "trainFinishNotice": userModel.trainFinishNotice,
        "trainPauseNotice": userModel.trainPauseNotice,
        "countdownNotice": userModel.countdownNotice,
        "trainActionNotice": userModel.trainActionNotice,
        "trainRestNotice": userModel.trainRestNotice,
        "trainCycleFinishNotice": userModel.trainCycleFinishNotice,
        "beginTrainNotice": userModel.beginTrainNotice,
        "endTrainNotice": userModel.endTrainNotice ] as [String : Any]
        
        
        let _ = self.createTable(keys: Array(dict.keys))
        if let dataArray = self.selectData(), dataArray.isEmpty == true, self.insertData(data: dict) {
            userModel.setValuesForKeys(dict)
            if userModel.trainActionsStr.isEmpty == false {
                userModel.trainActions = userModel.trainActionsStr.components(separatedBy: "&")
            }
            if userModel.totalTrainActionsStr.isEmpty == false {
                userModel.totalTrainActions = userModel.totalTrainActionsStr.components(separatedBy: "&")
            }
        } else {
            if self.updateData(keyValues: dict) == true {
                userModel.setValuesForKeys(dict)
                if userModel.trainActionsStr.isEmpty == false {
                    userModel.trainActions = userModel.trainActionsStr.components(separatedBy: "&")
                }
                if userModel.totalTrainActionsStr.isEmpty == false {
                    userModel.totalTrainActions = userModel.totalTrainActionsStr.components(separatedBy: "&")
                }
            }
        }
    }
    
    func splice(arr: Array<String>) -> String {
        
        var s = ""
        for i in 0..<arr.count {
            s += arr[i]
            if i != arr.count - 1 {
                s += "&"
            }
        }
        return s
    }
}
