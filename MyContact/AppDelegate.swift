//
//  AppDelegate.swift
//  MyContact
//
//  Created by pco2699 on 2017/06/05.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    //ナビゲーションアイテムの色を変更
    UINavigationBar.appearance().tintColor = UIColor.orange
    //ナビゲーションバーの背景を変更
    UINavigationBar.appearance().barTintColor = UIColor.statusBar
    //ナビゲーションのタイトル文字列の色を変更
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
    
    //起動中に通知を受け取るためのdelegate設定
    UNUserNotificationCenter.current().delegate = self
    
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  // アプリが foreground の時に通知を受け取った時に呼ばれるメソッド
  // MARK: - 起動中に通知が発生した場合
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert , .sound])
  }


}

