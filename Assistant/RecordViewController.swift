//
//  RecordViewController.swift
//  Assistant
//
//  Created by 飞亦 on 3/9/20.
//  Copyright © 2020 COB. All rights reserved.
//

import UIKit
import JXFoundation

//设备物理尺寸
let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenWidth = UIScreen.main.bounds.size.width

let ScreenProportion = ScreenWidth / 375

let IS_IPHONE_X: Bool = ScreenHeight == 812 || ScreenHeight == 896 ?true:false

let STATUS_NAV_BAR_Y:CGFloat = IS_IPHONE_X == true ? 88.0 : 64.0


private let cellId = "cellId"

class RecordViewController: UIViewController, TBCalendarDataDelegate , TBCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navi_HeightConstant: NSLayoutConstraint!{
        didSet{
            navi_HeightConstant.constant = kNavStatusHeight + 52
        }
    }
    
    
    lazy var calender: TBCalendar = self.getCalendar()
    lazy var style: TBCalendarAppearStyle = self.getStyle()
    
    
    lazy var formatter: DateFormatter = {
        let format = DateFormatter()
        return format
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.title = "日历"

        //NotificationCenter.default.addObserver(self, selector: #selector(changeDate(noty:)), name: NSNotification.Name(rawValue: CHANGE_SELECT_DATE), object: nil)


        self.calender.frame = CGRect.init(x: 20, y: navi_HeightConstant.constant, width: self.view.bounds.width - 40, height: 100)
        self.calender.backgroundColor = UIColor.white
        self.calender.layer.cornerRadius = 20
        self.calender.layer.masksToBounds = true
        
        self.view.addSubview(self.calender)
        
        
        self.tableView = UITableView(frame: CGRect.init(x: 20, y: 0, width: kScreenWidth - 40, height: kScreenHeight - kNavStatusHeight - 234 - 25), style: .plain)
        self.tableView?.backgroundColor = UIColor.clear
        
        self.tableView?.register(UINib.init(nibName: "RecordsCell", bundle: nil), forCellReuseIdentifier: cellId)
        //self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        self.tableView?.sectionFooterHeight = 0.1
        self.tableView?.tableFooterView = UIView()//group类型，设置高度不起作用
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.estimatedRowHeight = 44*kPercent
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = .none
   
        //self.tableView?.allowsMultipleSelectionDuringEditing =  true
        
        self.view.addSubview(self.tableView!)
        
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        self.formatter.dateFormat = "YYYY-MM-dd"
        let timeStr = self.formatter.string(from: Date())
        let s1 = TrainManager.shareInstance.selectData(keys: [], condition: ["ymd = '\(timeStr)'"]) as? Array<Dictionary<String, String>>
        let s2 = TrainManager.shareInstance.selectData()
        print(s1,s2)
        
        s1?.forEach({ (dict) in
            let entity = TrainModel()
            entity.setValuesForKeys(dict)
            self.dataArray.append(entity)
        })
    }
        
    func getCalendar() -> TBCalendar {
        let calendar = TBCalendar.init(style: self.style, frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))
        calendar.dataSource = self;
        calendar.delegate = self;
        return calendar
    }
    
    func getStyle() -> TBCalendarAppearStyle {
        let style = TBCalendarAppearStyle.init()
        style.isNeedCustomHeihgt = true;
        return style
    }
    
    // delegate And dateg
    func calender(calender: TBCalendar, layoutCallBackHeight: CGFloat) {
        
        self.calender.frame = CGRect.init(x: 20, y: navi_HeightConstant.constant, width: self.view.bounds.width - 40, height: layoutCallBackHeight)
        self.calender.layer.cornerRadius = 20
        
        self.tableView?.frame = CGRect.init(x: 20, y: self.calender.frame.maxY, width: kScreenWidth - 40, height: kScreenHeight - self.calender.frame.maxY)
    }
    
    func calender(calender: TBCalendar, didSelectDate: NSDate) {
        //这个地方可以做相应的点击某一天的数据处理
        print(didSelectDate)
        
        self.formatter.dateFormat = "YYYY-MM-dd"
        let timeStr = self.formatter.string(from: didSelectDate as Date)
        
        print(timeStr)
        
        let s1 = TrainManager.shareInstance.selectData(keys: [], condition: ["ymd = '\(timeStr)'"]) as? Array<Dictionary<String, String>>
        let s2 = TrainManager.shareInstance.selectData()
        print(s1,s2)
        self.dataArray.removeAll()
        s1?.forEach({ (dict) in
            let entity = TrainModel()
            entity.setValuesForKeys(dict)
            self.dataArray.append(entity)
        })
        self.tableView?.reloadData()
    }
    @IBAction func record(gender: UIButton) {
        print(1234)
    }

    var tableView : UITableView?
    var dataArray = [TrainModel]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RecordsCell
        let entity = self.dataArray[indexPath.row]
        cell.entity = entity
        return cell
      
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
