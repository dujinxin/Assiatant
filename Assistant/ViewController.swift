//
//  ViewController.swift
//  Assistant
//
//  Created by 飞亦 on 3/7/20.
//  Copyright © 2020 COB. All rights reserved.
//

import UIKit
import JXFoundation
import AVFoundation
import AudioToolbox

enum SelectNumType {
    case action
    case time
    case num
}
enum TrainState {
    case play
    case pause
    case stop
}

class ViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var arrowView: UILabel!
    

    
    
    //MARK: 训练前视图
    @IBOutlet weak var actionView: UIView!{
        didSet{
            actionView.clipsToBounds = true
            actionView.layer.cornerRadius = 20
            actionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(action(tap:))))
            actionView.tag = 1
        }
    }
    @IBOutlet weak var singleTView: UIView!{
        didSet{
            singleTView.layer.cornerRadius = 20
            singleTView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(action(tap:))))
            singleTView.tag = 2
        }
    }
    @IBOutlet weak var sTimeView: UIView!{
        didSet{
            sTimeView.layer.cornerRadius = 20
            sTimeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(action(tap:))))
            sTimeView.tag = 3
        }
    }
    @IBOutlet weak var cNumberView: UIView!{
        didSet{
            cNumberView.layer.cornerRadius = 20
            cNumberView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(action(tap:))))
            cNumberView.tag = 4
        }
    }
    @IBOutlet weak var csTimeView: UIView!{
        didSet{
            csTimeView.layer.cornerRadius = 20
            csTimeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(action(tap:))))
            csTimeView.tag = 5
        }
    }
    @IBOutlet weak var bottomView: UIView!{
        didSet{
            bottomView.layer.cornerRadius = 20
            bottomView.clipsToBounds = true
        }
    }
    @IBOutlet weak var brginView: UIView!{
        didSet{
            brginView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(action(tap:))))
            brginView.tag = 6
        }
    }
    @IBOutlet weak var endView: UIView!{
        didSet{
            endView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(action(tap:))))
            endView.tag = 7
        }
    }
    
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var actionNumLabel: UILabel!
    
    @IBOutlet weak var singTLabel: UILabel!
    @IBOutlet weak var sTimeLabel: UILabel!
    @IBOutlet weak var cNumberLabel: UILabel!
    @IBOutlet weak var csTimeLabel: UILabel!
    @IBOutlet weak var beginLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    
    
    
    
    
    
    //MARK: 训练中视图
    @IBOutlet weak var trainingBgView: UIView!{
        didSet{
            trainingBgView.backgroundColor = UIColor.groupTableViewBackground
            trainingBgView.isHidden = true
            trainingBgView.alpha = 1
        }
    }
    @IBOutlet weak var trainingTopView: UIView!{
        didSet{
            trainingTopView.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var trainingActionView: UIView!{
        didSet{
            trainingActionView.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var trainingCView: UIView!{
        didSet{
            trainingCView.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var trainingTView: UIView!{
        didSet{
            trainingTView.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var trainingLabel: UILabel!
    @IBOutlet weak var nextTrainLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBOutlet weak var trainActionLabel: UILabel!
    @IBOutlet weak var trainCircleLabel: UILabel!
    @IBOutlet weak var trainTimeLabel: UILabel!
    
    
    @IBOutlet weak var trainCurrentActionLabel: UILabel!
    @IBOutlet weak var trainCurrentCircleLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var processBgView: UIView!{
        didSet{
            processBgView.backgroundColor = UIColor.rgbColor(from: 236, 236, 236)
            processBgView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var processView: UIView!{
        didSet{
            processView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    

    //MARK: 公共视图
    @IBOutlet weak var startView: UIView!{
        didSet{
            startView.layer.cornerRadius = 45
            startView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(action(tap:))))
            startView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(long(press:))))
            
            startView.tag = 8
        }
    }
    @IBOutlet weak var startSubView: UIView!{
        didSet{
            startSubView.layer.cornerRadius = 42
            startSubView.layer.borderWidth = 2
            startSubView.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var soundView: UIButton!{
        didSet{
            soundView.setImage(UIImage(named: "voice_jh"), for: .selected)
            soundView.setImage(UIImage(named: "voice_wjh"), for: .normal)
        }
    }
    @IBOutlet weak var shockView: UIButton!
    {
        didSet{
            shockView.setImage(UIImage(named: "shake_jh"), for: .selected)
            shockView.setImage(UIImage(named: "shake_wjh"), for: .normal)
        }
    }
    @IBOutlet weak var noticeLabel: UILabel!{
        didSet{
            noticeLabel.isHidden = true
        }
    }
    

    lazy var selectView: JXSelectView = {
        let s = JXSelectView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 216), style: .pick)
        s.backgroundColor = UIColor.jxffffffColor
        s.delegate = self
        s.dataSource = self
        s.isUseSystemItemBar = true
        return s
    }()
    //MARK: custom Value
    
    
    var currentTag = 1
    
    
    var type = SelectNumType.time
    var state = TrainState.stop
    

    let mins: Int = 60
    let secs: Int = 60
    let nums: Int = 99
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var str = ""
        
        UserManager.shareInstance.userModel.trainActions.forEach { (s) in
            str += s
            str += "\n"
        }
        
        self.actionLabel.text = str
        self.actionNumLabel.text = "\(UserManager.shareInstance.userModel.trainActions.count)"
        
        self.singTLabel.text = String(format: "%02ld:%02ld", UserManager.shareInstance.userModel.singleTrainMinutes, UserManager.shareInstance.userModel.singleTrainSeconds)
        self.sTimeLabel.text = String(format: "%02ld:%02ld", UserManager.shareInstance.userModel.singleTrainIntervalMinutes, UserManager.shareInstance.userModel.singleTrainIntervalSeconds)
        self.cNumberLabel.text = "\(UserManager.shareInstance.userModel.cycleTrainNum)"
        self.csTimeLabel.text = String(format: "%02ld:%02ld", UserManager.shareInstance.userModel.cycleIntervalMinutes, UserManager.shareInstance.userModel.cycleIntervalSeconds)
        self.beginLabel.text = String(format: "%02ld:%02ld", UserManager.shareInstance.userModel.beginTrainMinutes, UserManager.shareInstance.userModel.beginTrainSeconds)
        self.endLabel.text = String(format: "%02ld:%02ld", UserManager.shareInstance.userModel.endTrainMinutes, UserManager.shareInstance.userModel.endTrainSeconds)
        
        self.shockView.isSelected = UserManager.shareInstance.userModel.useShock
        self.soundView.isSelected = UserManager.shareInstance.userModel.useVoice
        
    }

    @objc func action(tap: UITapGestureRecognizer) {
    
        guard let v = tap.view else { return }
        currentTag = v.tag
        
        if currentTag == 8 {
            
            self.noticeLabel.isHidden = false
            self.trainingBgView.isHidden = false
            
            if self.state == .stop {
                
                self.arrowView.isHidden = true
                self.recordButton.setTitle("训练中", for: .normal)
                self.recordButton.isEnabled = false
                self.settingButton.isHidden = true
                
                self.startLabel.text = "暂停"
                self.state = .play
                
                //语音播报
                if UserManager.shareInstance.userModel.trainStartNotice == true {
                    if UserManager.shareInstance.userModel.useVoice == true {
                        self.voiceBroadcast(string: "训练开始")
                    }
                    if UserManager.shareInstance.userModel.useShock == true {
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    }
                }
                self.countDown()
            } else if self.state == .pause {
                self.startLabel.text = "暂停"
                self.state = .play
                
                //语音播报
                if UserManager.shareInstance.userModel.trainStartNotice == true {
                    if UserManager.shareInstance.userModel.useVoice == true {
                        self.voiceBroadcast(string: "训练开始")
                    }
                    if UserManager.shareInstance.userModel.useShock == true {
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    }
                }
           
                self.timer?.resume()
            } else {
                self.startLabel.text = "GO"
                self.state = .pause
                
                //语音播报
                if UserManager.shareInstance.userModel.trainPauseNotice == true {
                    if UserManager.shareInstance.userModel.useVoice == true {
                        self.voiceBroadcast(string: "训练暂停")
                    }
                    if UserManager.shareInstance.userModel.useShock == true {
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                    }
                }
                
                self.timer?.suspend()
            }
            
        } else if currentTag == 1 {
            print(1)
            self.type = .action
            let vc = ActionListController()
            let nvc = UINavigationController(rootViewController: vc)
            vc.actions = UserManager.shareInstance.userModel.trainActions
            vc.backBlock = { arr in
                UserManager.shareInstance.userModel.trainActions = arr
                UserManager.shareInstance.userModel.trainActionsStr = UserManager.shareInstance.splice(arr: arr)
                UserManager.shareInstance.updateUserInfo()
                
                
                var str = ""
                UserManager.shareInstance.userModel.trainActions.forEach { (s) in
                    str += s
                    str += "\n"
                }
                self.actionNumLabel.text = "\(UserManager.shareInstance.userModel.trainActions.count)"
                self.actionLabel.text = str
            }
            self.present(nvc, animated: true) {
                
            }
        } else {
            switch tap.view?.tag {
            
                case 2:
                    self.type = .time
                    self.selectView.selectRow = UserManager.shareInstance.userModel.singleTrainMinutes
                    self.selectView.selectSecondRow = UserManager.shareInstance.userModel.singleTrainSeconds
                case 3:
                    self.type = .time
                    self.selectView.selectRow = UserManager.shareInstance.userModel.singleTrainIntervalMinutes
                    self.selectView.selectSecondRow = UserManager.shareInstance.userModel.singleTrainIntervalSeconds
                case 5:
                    self.type = .time
                    self.selectView.selectRow = UserManager.shareInstance.userModel.cycleIntervalMinutes
                    self.selectView.selectSecondRow = UserManager.shareInstance.userModel.cycleIntervalSeconds
                case 6:
                    self.type = .time
                    self.selectView.selectRow = UserManager.shareInstance.userModel.beginTrainMinutes
                    self.selectView.selectSecondRow = UserManager.shareInstance.userModel.beginTrainSeconds
                case 7:
                    self.type = .time
                    self.selectView.selectRow = UserManager.shareInstance.userModel.endTrainMinutes
                    self.selectView.selectSecondRow = UserManager.shareInstance.userModel.endTrainSeconds
                case 4:
                    self.type = .num
                    self.selectView.selectRow = UserManager.shareInstance.userModel.cycleTrainNum - 1
                    self.selectView.selectSecondRow = -1
                default:
                    self.type = .time
                }
            self.selectView.show(inView: self.view, animate: true)
        }
      
    }
    @objc func long(press: UITapGestureRecognizer) {
        guard let _ = press.view, self.state != .stop else { return }
        
        self.arrowView.isHidden = false
        self.recordButton.setTitle("训练", for: .normal)
        self.recordButton.isEnabled = true
        self.settingButton.isHidden = false
        
        self.state = .stop
        
        self.startLabel.text = "GO"
        self.noticeLabel.isHidden = true
        self.trainingBgView.isHidden = true
        
        self.timer?.setCancelHandler(handler: {
            print("cancel")
        })
        self.timer?.cancel()
        self.timer = nil
        
        print(self.timer?.isCancelled)
        //self.timer = nil
        
        //语音播报
        if UserManager.shareInstance.userModel.trainStopNotice == true {
            if UserManager.shareInstance.userModel.useVoice == true {
                self.voiceBroadcast(string: "退出训练")
            }
            if UserManager.shareInstance.userModel.useShock == true {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
        }
    }
    
    @IBAction func shock(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        UserManager.shareInstance.userModel.useShock = sender.isSelected
        UserManager.shareInstance.updateUserInfo()
    }
    @IBAction func voice(_ sender: UIButton) {
        //self.voiceBroadcast(string: "我爱你中国")
        
        sender.isSelected = !sender.isSelected
        
        UserManager.shareInstance.userModel.useVoice = sender.isSelected
        UserManager.shareInstance.updateUserInfo()
    }
    
    @IBAction func exit(segue: UIStoryboardSegue) {
        print(12345)
    }

    //MARK: timer
    var timer: DispatchSourceTimer?
    lazy var formatter: DateFormatter = {
        let format = DateFormatter()
        return format
    }()

    var totalSeconds = 0
    var singleCircleSeconds = 0
    var trainSeconds = 0
    

    func countDown() {
        
        self.singleCircleSeconds = 0
        self.totalSeconds = 0
       
        //配置每一个小倒计时
        //单次 开头热身运动+（动作单次训练+ 时间间隔  +...  + 动作单词训练）+结尾拉伸运动
        //多循环 开头热身运动+（动作单次训练+ 时间间隔 +  ...+ 动作单词训练） + 循环间隔 + （动作单次训练+ 时间间隔 +  ...+ 动作单词训练）+ ... + 结尾拉伸运动
        var countArray: Array<Dictionary<String, Any>> = Array()
        
        //type 0训练休息，1正式训练，2循环间隙，3热身运动, 4拉伸运动；tag 1,2,3动作
        //
        countArray.append([
            "seconds": UserManager.shareInstance.userModel.beginTrainMinutes * 60 + UserManager.shareInstance.userModel.beginTrainSeconds,
            "type": 3, "tag": -1, "text": "热身运动"])
        for i in 0..<UserManager.shareInstance.userModel.trainActions.count {
            countArray.append([
            "seconds": UserManager.shareInstance.userModel.singleTrainMinutes * 60 + UserManager.shareInstance.userModel.singleTrainSeconds,
            "type": 1, "tag": i, "text": UserManager.shareInstance.userModel.trainActions[i]])
            if i != UserManager.shareInstance.userModel.trainActions.count - 1 {
                countArray.append([
                "seconds": UserManager.shareInstance.userModel.singleTrainIntervalMinutes * 60 + UserManager.shareInstance.userModel.singleTrainIntervalSeconds,
                "type": 0, "tag": i, "text": "休息"])
            }
            
            self.singleCircleSeconds += (UserManager.shareInstance.userModel.singleTrainMinutes * 60 + UserManager.shareInstance.userModel.singleTrainSeconds)
            self.singleCircleSeconds += (UserManager.shareInstance.userModel.singleTrainIntervalMinutes * 60 + UserManager.shareInstance.userModel.singleTrainIntervalSeconds)
            
            self.totalSeconds += (UserManager.shareInstance.userModel.singleTrainMinutes * 60 + UserManager.shareInstance.userModel.singleTrainSeconds)
            self.totalSeconds += (UserManager.shareInstance.userModel.singleTrainIntervalMinutes * 60 + UserManager.shareInstance.userModel.singleTrainIntervalSeconds)
          
        }
        
        if UserManager.shareInstance.userModel.cycleTrainNum == 1 {
            countArray.append([
            "seconds": UserManager.shareInstance.userModel.endTrainMinutes * 60 + UserManager.shareInstance.userModel.endTrainSeconds,
            "type": 4, "tag": -1, "text": "拉伸运动"])
            
        } else {
            for _ in 1..<UserManager.shareInstance.userModel.cycleTrainNum {
                countArray.append([
                "seconds": UserManager.shareInstance.userModel.cycleIntervalMinutes * 60 + UserManager.shareInstance.userModel.cycleIntervalSeconds,
                "type": 2, "tag": -1, "text": "组间休息"])
                
                self.totalSeconds += (UserManager.shareInstance.userModel.cycleIntervalMinutes * 60 + UserManager.shareInstance.userModel.cycleIntervalSeconds)
                
                for i in 0..<UserManager.shareInstance.userModel.trainActions.count {
                    countArray.append([
                    "seconds": UserManager.shareInstance.userModel.singleTrainMinutes * 60 + UserManager.shareInstance.userModel.singleTrainSeconds,
                    "type": 1, "tag": i, "text": UserManager.shareInstance.userModel.trainActions[i]])
                    if i != UserManager.shareInstance.userModel.trainActions.count - 1 {
                        countArray.append([
                        "seconds": UserManager.shareInstance.userModel.singleTrainIntervalMinutes * 60 + UserManager.shareInstance.userModel.singleTrainIntervalSeconds,
                        "type": 0, "tag": i, "text": "休息"])
                    }
                    
                    self.totalSeconds += (UserManager.shareInstance.userModel.singleTrainMinutes * 60 + UserManager.shareInstance.userModel.singleTrainSeconds)
                    self.totalSeconds += (UserManager.shareInstance.userModel.singleTrainIntervalMinutes * 60 + UserManager.shareInstance.userModel.singleTrainIntervalSeconds)
                }
            }
            countArray.append([
            "seconds": UserManager.shareInstance.userModel.endTrainMinutes * 60 + UserManager.shareInstance.userModel.endTrainSeconds,
            "type": 4, "tag": -1, "text": "拉伸运动"])
        }
        self.totalSeconds += (UserManager.shareInstance.userModel.endTrainMinutes * 60 + UserManager.shareInstance.userModel.endTrainSeconds)
        
        self.totalLabel.text = "总时长 \(self.getCountDownStr(timeInterval: self.totalSeconds))"
        var seconds = self.totalSeconds
        
        let queue = DispatchQueue.global(qos: .default)
        let t = DispatchSource.makeTimerSource(flags: [], queue: queue)
        self.timer = t
        
        self.timer?.schedule(wallDeadline: DispatchWallTime.now(), repeating: 1)
        self.timer?.setEventHandler {
            DispatchQueue.main.async {
                
                if seconds <= 0 {
                    let s = UserManager.shareInstance.userModel.trainActionsStr
                    let ns = s.replacingOccurrences(of: "&", with: ">")
                    
                    self.formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                    let timeStr = self.formatter.string(from: Date())
                    
                    self.formatter.dateFormat = "YYYY-MM-dd"
                    let ymd = self.formatter.string(from: Date())
                    
                    let dict = ["trainActionsStr": ns,
                    "totalTrainSeconds": self.totalSeconds,
                    "time": timeStr, "ymd": ymd] as [String : Any]
                    
                    let _ = TrainManager.shareInstance.createTable(keys: Array(dict.keys))
                    let _ = TrainManager.shareInstance.insertData(data: dict)
                    
                    //语音播报
                    if UserManager.shareInstance.userModel.trainFinishNotice == true {
                        if UserManager.shareInstance.userModel.useVoice == true {
                            self.voiceBroadcast(string: "训练完成")
                        }
                        if UserManager.shareInstance.userModel.useShock == true {
                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                        }
                    }
                    
                    //头部视图变化
                    self.arrowView.isHidden = false
                    self.recordButton.setTitle("训练", for: .normal)
                    self.recordButton.isEnabled = true
                    self.settingButton.isHidden = false
                    
                    //底部视图变化
                    self.state = .stop
                    self.startLabel.text = "GO"
                    self.noticeLabel.isHidden = true
                    self.trainingBgView.isHidden = true
                    
                    self.timer?.cancel()
                    self.timer = nil
                    
                } else {
                    
                    self.trainSeconds += 1
                    
                    guard let dict = countArray.first else { return }
                    let first = dict["seconds"] as! Int
                    //单个动作或休息倒计时
                    var single: Int = first
                    
                    //单计时
                    self.countDownLabel.text = self.getCountDownStr(timeInterval: single)
                    //总训练倒计时
                    self.trainTimeLabel.text = self.getCountDownStr(timeInterval: seconds)
                    //进度条
                    self.widthConstraint.constant = (kScreenWidth - 40) * CGFloat(self.trainSeconds) / CGFloat(self.totalSeconds)
                    
                    
                    let d = dict["tag"] as! Int
                    let type = dict["type"] as! Int
                    let text = dict["text"] as! String
                    //当前状态&下个动作
                    //type 0训练休息，1正式训练，2循环间隙，3热身运动, 4拉伸运动
                    if type == 0 {
                        self.trainingLabel.text = "休息"
                        self.nextTrainLabel.text = "下个动作：\(UserManager.shareInstance.userModel.trainActions[d + 1])"
                        
                        
                        //语音播报, 时间间隔大于8秒，有倒计时
                        if UserManager.shareInstance.userModel.trainRestNotice == true && single == (UserManager.shareInstance.userModel.singleTrainIntervalMinutes * 60 + UserManager.shareInstance.userModel.singleTrainIntervalSeconds) {
                            
                            if UserManager.shareInstance.userModel.useVoice == true {
                                self.voiceBroadcast(string: "休息一下，下个动作\(UserManager.shareInstance.userModel.trainActions[d + 1])")
                            }
                            if UserManager.shareInstance.userModel.useShock == true {
                                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                            }
                        }
                        
                        if UserManager.shareInstance.userModel.countdownNotice == true && (UserManager.shareInstance.userModel.singleTrainIntervalMinutes * 60 + UserManager.shareInstance.userModel.singleTrainIntervalSeconds) > 8{
                            if single == 3 {
                                
                                if UserManager.shareInstance.userModel.useVoice == true {
                                    self.voiceBroadcast(string: "三")
                                }
                                if UserManager.shareInstance.userModel.useShock == true {
                                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                }
                            } else if single == 2 {
                                if UserManager.shareInstance.userModel.useVoice == true {
                                    self.voiceBroadcast(string: "二")
                                }
                                if UserManager.shareInstance.userModel.useShock == true {
                                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                }
                            } else if single == 1 {
                                if UserManager.shareInstance.userModel.useVoice == true {
                                    self.voiceBroadcast(string: "一")
                                }
                                if UserManager.shareInstance.userModel.useShock == true {
                                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                }
                            }
                        }
                        
                    } else if type == 1 {
                        self.trainingLabel.text = "训练"
                        self.nextTrainLabel.text = "\(d + 1).\(text)"
                        
                        //语音播报, 时间间隔大于10秒，有倒计时
                        if UserManager.shareInstance.userModel.trainActionNotice == true && single == (UserManager.shareInstance.userModel.singleTrainMinutes * 60 + UserManager.shareInstance.userModel.singleTrainSeconds) {
                            
                            if UserManager.shareInstance.userModel.useVoice == true {
                                self.voiceBroadcast(string: "\(UserManager.shareInstance.userModel.trainActions[d])")
                            }
                            if UserManager.shareInstance.userModel.useShock == true {
                                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                            }
                        }
                    } else if type == 2 {
                        self.trainingLabel.text = "组间休息"
                        self.nextTrainLabel.text = "下个动作：\(UserManager.shareInstance.userModel.trainActions[0])"
                        
                        //语音播报, 时间间隔大于10秒，有倒计时
                        if UserManager.shareInstance.userModel.trainCycleFinishNotice == true && single == (UserManager.shareInstance.userModel.cycleIntervalMinutes * 60 + UserManager.shareInstance.userModel.cycleIntervalSeconds) {
                            
                            if UserManager.shareInstance.userModel.useVoice == true {
                                self.voiceBroadcast(string: "休息一下，一组循环已完成，下个动作\(UserManager.shareInstance.userModel.trainActions[0])")
                            }
                            if UserManager.shareInstance.userModel.useShock == true {
                                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                            }
                        }
                        if UserManager.shareInstance.userModel.countdownNotice == true && (UserManager.shareInstance.userModel.cycleIntervalMinutes * 60 + UserManager.shareInstance.userModel.cycleIntervalSeconds) > 10{
                            if single == 3 {
                                
                                if UserManager.shareInstance.userModel.useVoice == true {
                                    self.voiceBroadcast(string: "三")
                                }
                                if UserManager.shareInstance.userModel.useShock == true {
                                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                }
                            } else if single == 2 {
                                
                                if UserManager.shareInstance.userModel.useVoice == true {
                                    self.voiceBroadcast(string: "二")
                                }
                                if UserManager.shareInstance.userModel.useShock == true {
                                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                }
                            } else if single == 1 {
                                
                                if UserManager.shareInstance.userModel.useVoice == true {
                                    self.voiceBroadcast(string: "一")
                                }
                                if UserManager.shareInstance.userModel.useShock == true {
                                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                }
                            }
                            
                        }
                    } else if type == 3 {
                        self.trainingLabel.text = text
                        self.nextTrainLabel.text = "下个动作：\(UserManager.shareInstance.userModel.trainActions[0])"
                        
                        //语音播报
                        if UserManager.shareInstance.userModel.trainActionNotice == true && single == (UserManager.shareInstance.userModel.beginTrainMinutes * 60 + UserManager.shareInstance.userModel.beginTrainSeconds) {
                            
                            if UserManager.shareInstance.userModel.useVoice == true {
                                self.voiceBroadcast(string: "热身运动")
                            }
                            if UserManager.shareInstance.userModel.useShock == true {
                                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                            }
                        }
                        if UserManager.shareInstance.userModel.countdownNotice == true && (UserManager.shareInstance.userModel.beginTrainMinutes * 60 + UserManager.shareInstance.userModel.beginTrainSeconds) > 10{
                            if single == 3 {
                                
                                if UserManager.shareInstance.userModel.useVoice == true {
                                    self.voiceBroadcast(string: "三")
                                }
                                if UserManager.shareInstance.userModel.useShock == true {
                                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                }
                            } else if single == 2 {
                                
                                if UserManager.shareInstance.userModel.useVoice == true {
                                    self.voiceBroadcast(string: "二")
                                }
                                if UserManager.shareInstance.userModel.useShock == true {
                                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                }
                            } else if single == 1 {
                                
                                if UserManager.shareInstance.userModel.useVoice == true {
                                    self.voiceBroadcast(string: "一")
                                }
                                if UserManager.shareInstance.userModel.useShock == true {
                                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                                }
                            }
                        }
                    } else {
                        self.trainingLabel.text = text
                        self.nextTrainLabel.text = ""
                    }
                    
                    
                    //动作
                    
                    self.trainCurrentActionLabel.text = "\(d + 1)"
                    self.trainActionLabel.text = "/\(UserManager.shareInstance.userModel.trainActions.count)"
                    //循环
                    if ((self.trainSeconds - (UserManager.shareInstance.userModel.beginTrainMinutes * 60 + UserManager.shareInstance.userModel.beginTrainSeconds)) / self.singleCircleSeconds) < UserManager.shareInstance.userModel.cycleTrainNum {
                        
                        self.trainCurrentCircleLabel.text = "\((self.trainSeconds - (UserManager.shareInstance.userModel.beginTrainMinutes * 60 + UserManager.shareInstance.userModel.beginTrainSeconds)) / self.singleCircleSeconds + 1)"
                        self.trainCircleLabel.text = "/\(UserManager.shareInstance.userModel.cycleTrainNum )"
                    } else {
                        self.trainCurrentCircleLabel.text = "\(UserManager.shareInstance.userModel.cycleTrainNum )"
                        self.trainCircleLabel.text = "/\(UserManager.shareInstance.userModel.cycleTrainNum)"
                    }
                    
                    seconds -= 1
                    single -= 1
                    
                    if countArray.count > 0 && single > 0 {
                        var dict = countArray[0]
                        dict["seconds"] = single
                        countArray[0] = dict
                    }
                    
                    if single == 0 {
                        countArray.removeFirst()
                    }
                    
                    
                }
            }
        }
        self.timer?.activate()
    }

    func getCountDownStr(timeInterval: Int) -> String {
        if timeInterval <= 0 {
            return "00:00"
        }
        let days = timeInterval / (3600 * 24)
        let hours = (timeInterval - days * 24 * 3600) / 3600
        let minutes = (timeInterval - days * 24 * 3600 - hours * 3600) / 60
        let seconds = timeInterval - days * 24 * 3600 - hours * 3600 - minutes * 60
        
        
        if days > 0 {
            return String(format: "%02ld:%02ld:%02ld:%02ld", days,hours,minutes,seconds)
        } else {
            if hours > 0 {
                return String(format: "%02ld:%02ld:%02ld", hours,minutes,seconds)
            } else {
                if minutes > 0 {
                    return String(format: "%02ld:%02ld", minutes,seconds)
                } else {
                    return String(format: "00:%02ld", seconds)
                }
            }
        }
    }
    deinit {
        self.timer?.cancel()
        
    }
    
    //MARK: TTS
    func voiceBroadcast(string: String) {
        let utt = AVSpeechUtterance.init(string: string)
        utt.pitchMultiplier = 0.8
        let voice = AVSpeechSynthesisVoice.init(language: "zh-CH")
        
        utt.voice = voice
        
        //print(AVSpeechSynthesisVoice.speechVoices())
        let synth = AVSpeechSynthesizer.init()
        synth.speak(utt)
    }
}

extension ViewController: JXSelectViewDelegate, JXSelectViewDataSource {
    
    func jxSelectView(selectView: JXSelectView, didSelectRowAt row: Int, inSection section: Int) {
        print(row)
  
        switch currentTag {
            case 2:
                UserManager.shareInstance.userModel.singleTrainMinutes = selectView.selectRow
                UserManager.shareInstance.userModel.singleTrainSeconds = selectView.selectSecondRow
                self.singTLabel.text = String(format: "%02ld:%02ld", selectView.selectRow, selectView.selectSecondRow)
            
            case 3:
                UserManager.shareInstance.userModel.singleTrainIntervalMinutes = selectView.selectRow
                UserManager.shareInstance.userModel.singleTrainIntervalSeconds = selectView.selectSecondRow
                self.sTimeLabel.text = String(format: "%02ld:%02ld", selectView.selectRow, selectView.selectSecondRow)
            case 5:
                UserManager.shareInstance.userModel.cycleIntervalMinutes = selectView.selectRow
                UserManager.shareInstance.userModel.cycleIntervalSeconds = selectView.selectSecondRow
                self.csTimeLabel.text = String(format: "%02ld:%02ld", selectView.selectRow, selectView.selectSecondRow)
            case 6:
                UserManager.shareInstance.userModel.beginTrainMinutes = selectView.selectRow
                UserManager.shareInstance.userModel.beginTrainSeconds = selectView.selectSecondRow
                self.beginLabel.text = String(format: "%02ld:%02ld", selectView.selectRow, selectView.selectSecondRow)
            case 7:
                UserManager.shareInstance.userModel.endTrainMinutes = selectView.selectRow
                UserManager.shareInstance.userModel.endTrainSeconds = selectView.selectSecondRow
                self.endLabel.text = String(format: "%02ld:%02ld", selectView.selectRow, selectView.selectSecondRow)
            case 4:
                UserManager.shareInstance.userModel.cycleTrainNum = selectView.selectRow + 1
                self.cNumberLabel.text = "\(self.selectView.selectRow + 1)"
            default:
                print("错误")
            
        }
        UserManager.shareInstance.updateUserInfo()
    }
    func numberOfComponents(selectView: JXSelectView) -> Int {
        if type == .time {
            return 2
        } else {
            return 1
        }
    }
    func jxSelectView(selectView: JXSelectView, numberOfRowsInSection section: Int) -> Int {
        
        switch type {
        case .action:
            return UserManager.shareInstance.userModel.trainActions.count
        case .time:
            if section == 0 {
                return mins
            } else {
                return secs
            }
        case .num:
            return nums
        }
    }

    func jxSelectView(selectView: JXSelectView, widthForComponent component: Int) -> CGFloat {
        return kScreenWidth / 3
    }
    func jxSelectView(selectView: JXSelectView, heightForRowAt row: Int) -> CGFloat {
        return 36
    }

    func jxSelectView(selectView: JXSelectView, contentForRow row: Int, InSection section: Int) -> String {
        switch type {
        case .action:
            return UserManager.shareInstance.userModel.trainActions[row]
        case .time:
            return String(format: "%02ld", row)
        case .num:
            return String(format: "%02ld", row + 1)
        }
    }
    
}
