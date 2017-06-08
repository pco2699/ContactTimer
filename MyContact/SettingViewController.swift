//
//  SettingViewController.swift
//  MyContact
//
//  Created by pco2699 on 2017/06/07.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import UIKit
import UserNotifications

class SettingViewController: UIViewController, UNUserNotificationCenterDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  @IBOutlet weak var dateSettingPicker: UIDatePicker!
  @IBOutlet weak var alarmSwitch: UISwitch!
  @IBOutlet weak var alarmTimePicker: UIDatePicker!
  
  @IBAction func switchChangedAciton(_ sender: Any) {
    let calendar = Calendar(identifier: .gregorian)
    let alarm_date = dateSettingPicker.date
    let alarm_time = alarmTimePicker.date
    
    let settingDate = DateComponents(year: calendar.component(.year, from: alarm_date), month: calendar.component(.month, from: alarm_date), day: calendar.component(.day, from: alarm_date),
                                     hour: calendar.component(.hour, from: alarm_time), minute: calendar.component(.minute, from: alarm_time))

    if alarmSwitch.isOn {
      setLocalNotification(settingDate)
    }
    else {
      deleteLocalNotification("ContactNotification")
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // UserDefaulsのインスタンスを生成
    let settings = UserDefaults.standard
    
    // UserDefaultsからデータを取得
    let deadline_date = settings.object(forKey: "deadline_date") as? Date
    // var deadline_days = settings.integer(forKey: "deadline_days")
    
    dateSettingPicker.date = deadline_date!
    alarmTimePicker.date = deadline_date!
  }
  
  @IBAction func dateChangedAction(_ sender: Any) {
    // UserDefaulsのインスタンスを生成
    let settings = UserDefaults.standard
    
    // UserDefaultsにデータを設定
    settings.setValue(dateSettingPicker.date, forKey: "deadline_date")
    settings.synchronize()
  
  }
  
  func setLocalNotification(_ date: DateComponents) {
    // UNMutableNotificationContent 作成
    let content = UNMutableNotificationContent()
    content.title = "コンタクトアラート"
    content.body = "コンタクトの期限がきました"
    content.sound = .default()
    
    // 5秒後に発火する UNTimeIntervalNotificationTrigger 作成、
    let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: false)
    
    // identifier, content, trigger から UNNotificationRequest 作成
    let request = UNNotificationRequest.init(identifier: "ContactNotification", content: content, trigger: trigger)
    
    // UNUserNotificationCenter に request を追加
    let center = UNUserNotificationCenter.current()
    center.add(request)
    // デリゲートを設定
    center.delegate = self;
  }
  
  func deleteLocalNotification(_ identifier: String) {
    // UNUserNotificationCenter に request を追加
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [identifier])
  }
  
  // アプリが foreground の時に通知を受け取った時に呼ばれるメソッド
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let alert = UIAlertController(title: "コンタクトアラート", message: "コンタクトの期限がきました", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
      //無処理
    }))
    
    present(alert, animated: true, completion: nil)
  }
  
}
