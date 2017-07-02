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
  // 本日の日付を設定する定数
  var today_date: Date?
  // カレンダー設定
  var calendar: Calendar?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // カレンダーを西暦に設定
    calendar = Calendar(identifier: .gregorian)
    
    // Pickerの色を変える設定
    dateSettingPicker.setValue(UIColor.white, forKey: "textColor")
    dateSettingPicker.setValue(false, forKey: "highlightsToday")
    
    alarmTimePicker.setValue(UIColor.white, forKey: "textColor")
    alarmTimePicker.setValue(false, forKey: "highlightsToday")
    
    // Do any additional setup after loading the view.
    
    // UserDefaulsのインスタンスを生成
    let settings = UserDefaults.standard
    
    // UserDefaultsからコンタクトの期限を取得
    let deadline_date = settings.object(forKey: "deadline_date") as? Date
    
    // UserDefaultsから現在日付を取得
    today_date = Date()
    
    // Pickerに設定
    dateSettingPicker.date = deadline_date!
    alarmTimePicker.date = deadline_date!
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
  
  // 通知設定がON/OFFされたときに呼び出されるAction
  @IBAction func switchChangedAciton(_ sender: Any) {
    let alarm_date = dateSettingPicker.date
    let alarm_time = alarmTimePicker.date
    
    // 設定された時刻からDateComponetsを設定
    let settingDate = DateComponents(year: calendar?.component(.year, from: alarm_date), month: calendar?.component(.month, from: alarm_date), day: calendar?.component(.day, from: alarm_date),
                                     hour: calendar?.component(.hour, from: alarm_time), minute: calendar?.component(.minute, from: alarm_time))

    // もしアラームスイッチがONならばローカル通知設定
    if alarmSwitch.isOn {
      setLocalNotification(settingDate)
    }
    else {
      deleteLocalNotification("ContactNotification")
    }
  }
  
  
  // 期限日付を変更されるAction
  @IBAction func dateChangedAction(_ sender: Any) {
    // UserDefaulsのインスタンスを生成
    let settings = UserDefaults.standard
    
    // UserDefaultsにデータを設定
    settings.setValue(dateSettingPicker.date, forKey: "deadline_date")
    settings.synchronize()
  
  }
  
  // ローカル通知を設定する関数
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
  
  // ローカル通知を削除する関数
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
  @IBOutlet weak var o_w_button_outlet: EditableButton!
  @IBOutlet weak var t_w_button_outlet: EditableButton!
  @IBOutlet weak var o_m_button_outlet: EditableButton!
  
  @IBAction func o_w_button_action(_ sender: Any) {
    o_m_button_outlet.isEnabled = false
    t_w_button_outlet.isEnabled = true
    o_m_button_outlet.isEnabled = true
  }
  
  @IBAction func t_w_button_action(_ sender: Any) {
    o_m_button_outlet.isEnabled = true
    t_w_button_outlet.isEnabled = false
    o_m_button_outlet.isEnabled = true
  }
  
  @IBAction func o_m_button_action(_ sender: Any) {
    o_m_button_outlet.isEnabled = true
    t_w_button_outlet.isEnabled = true
    o_m_button_outlet.isEnabled = false
  }
}
