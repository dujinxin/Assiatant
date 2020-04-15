//
//  Attribute.swift
//  Assistant
//
//  Created by 飞亦 on 3/9/20.
//  Copyright © 2020 COB. All rights reserved.
//

import UIKit


enum SelectType{ //日历选择的类型 可选一天日期/可选一个日期区间
    case SelectTypeOneDate
    case SelectTypeAreaDate
}

class Attribute: NSObject {

    //var startDate : Int? = 0
    //var endDate   : Int? = 0
    //var limitMonth: NSInteger? // 可选择的月份数量
    //var type : ZGSenctionScalendarType = ZGSenctionScalendarType.ZGSenctionScalendarFutureType
    var selectType : SelectType = SelectType.SelectTypeAreaDate
    var afterTodayCanTouch : Bool = true
    var BeforeTodayCanTouch: Bool = false
    var showChineseHoliday : Bool = true
    var ShowChineseCalendar: Bool = true
    var ShowHolidayColor   : Bool = true
}
