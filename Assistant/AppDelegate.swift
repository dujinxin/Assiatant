//
//  AppDelegate.swift
//  Assistant
//
//  Created by 飞亦 on 3/7/20.
//  Copyright © 2020 COB. All rights reserved.
//

import UIKit
import JXFoundation

let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
//=================系统参数相关===============
// iPhone X
let iPhoneX = (kScreenWidth == 375 && kScreenHeight == 812) ? true : false
let CURRENT_SYS_VERSION = (UIDevice.current.systemVersion as NSString).floatValue
let IOS8 = (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0
let NAV_HEIGHT = iPhoneX ? (44 + 44) : 64
let TABBAR_HEIGHT = iPhoneX ? (49 + 34) : 49
let kTabbarSafeBottomMargin = iPhoneX ? 34 : 0
let BATTERY_BARHEIGHT = iPhoneX ? 44 : 20
//===================================


let JXMainColor = UIColor.rgbColor(from: 68, 32, 143)
let JXMainTextColor = UIColor.rgbColor(from: 124, 134, 162)

enum TBCalendarHeaderViewType: Int {
    case leftDate
    case centerDate
}

let CHANGE_SELECT_DATE: String = "change_select_date"



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

