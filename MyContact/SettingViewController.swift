//
//  SettingViewController.swift
//  MyContact
//
//  Created by pco2699 on 2017/06/07.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import UIKit
import UserNotifications

class SettingViewController: UIViewController {
  // 本日の日付を設定する定数
  var today_date: Date?
  // カレンダー設定
  var calendar: Calendar?
  // コンタクト期限
  var deadline_date: Date?
  // アラーム時刻
  var alarm_time: Date?
  // 期限日数
  var deadline_days: Int?
  
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
    
    //トップに戻るボタンを作成
    let leftButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goTop))
    self.navigationItem.leftBarButtonItem = leftButton
  }
  
  func goTop(){
    // 保存アラートを出す
    let alert = UIAlertController(title: "確認", message: "設定値を保存します", preferredStyle:  UIAlertControllerStyle.alert)
    
    let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
      // ボタンが押された時の処理を書く（クロージャ実装）
      (action: UIAlertAction!) -> Void in
      
      self.saveParameters()
      //トップ画面に戻る。
      self.navigationController?.popToRootViewController(animated: true)

    })
    // キャンセルボタン
    let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{(action: UIAlertAction!) in
      })
    
    // UIAlertControllerにActionを追加
    alert.addAction(cancelAction)
    alert.addAction(defaultAction)
    
    // Alertを表示
    present(alert, animated: true, completion: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // UserDefaulsのインスタンスを生成
    let settings = UserDefaults.standard
    
    // UserDefaultsからコンタクトの期限を取得
    deadline_date = settings.object(forKey: "deadline_date") as? Date
    
    // UserDefaultsからコンタクトの期限日数を取得
    deadline_days = settings.integer(forKey: "deadline_days")
    
    // UserDefaultsからアラーム日付を取得
    alarm_time = settings.object(forKey: "alarm_time") as? Date
    
    let alarm_switch_state = settings.object(forKey: "alarm_switch_state") as? Bool
    

    switch deadline_days! {
    case 14:
      t_w_button_action(self)
      break
    case 30:
      o_m_button_action(self)
      break
    case 7:
      o_w_button_action(self)
      break
    default:
      break
    }
    
    // 現在日付を取得
    today_date = Date()
    
    // Pickerに設定
    dateSettingPicker.date = deadline_date!
    alarmTimePicker.date = alarm_time!
    
    if let al_state = alarm_switch_state {
      alarmSwitch.setOn(al_state, animated: false)
    }
    
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

  func saveParameters() {
    // UserDefaulsのインスタンスを生成
    let settings = UserDefaults.standard
    
    let deadline_date_setted = dateSettingPicker.date
    let alarm_time_setted = alarmTimePicker.date
    
    // 設定された時刻からDateComponetsを設定
    if let cal = calendar {
      let settingDate = returnDateComponentsforNotification(calendar: cal, deadline_date: deadline_date_setted, alarm_time: alarm_time_setted)
      // もしアラームスイッチがONならばローカル通知設定
      if alarmSwitch.isOn {
        setLocalNotification(settingDate)
      }
      else {
        deleteLocalNotification("ContactNotification")
      }
    }
    
    // UserDefaultsにデータを設定
    settings.setValue(alarmSwitch.isOn, forKey: "alarm_switch_state")
    settings.setValue(deadline_date_setted, forKey: "deadline_date")
    settings.setValue(alarm_time_setted, forKey: "alarm_time")
    settings.setValue(deadline_days, forKey: "deadline_days")
    
    settings.synchronize()
    
  }


  @IBOutlet weak var o_w_button_outlet: EditableButton!
  @IBOutlet weak var t_w_button_outlet: EditableButton!
  @IBOutlet weak var o_m_button_outlet: EditableButton!
  
  @IBAction func o_w_button_action(_ sender: Any) {
    // 1週間ボタンが押されたので、そのボタンを不活性にし
    // それ以外を活性にする
    changeButtonState(button: o_w_button_outlet, state: false)
    changeButtonState(button: t_w_button_outlet, state: true)
    changeButtonState(button: o_m_button_outlet, state: true)
    
    changeDeadlineDate(sender, days: 7)
    
  }
  
  @IBAction func t_w_button_action(_ sender: Any) {
    // 2週間ボタンが押されたので、そのボタンを不活性にし
    // それ以外を活性にする
    changeButtonState(button: o_w_button_outlet, state: true)
    changeButtonState(button: t_w_button_outlet, state: false)
    changeButtonState(button: o_m_button_outlet, state: true)
    
    changeDeadlineDate(sender, days: 14)
    
  }
  
  @IBAction func o_m_button_action(_ sender: Any) {
    // 1ヶ月ボタンが押されたので、そのボタンを不活性にし
    // それ以外を活性にする
    changeButtonState(button: o_w_button_outlet, state: true)
    changeButtonState(button: t_w_button_outlet, state: true)
    changeButtonState(button: o_m_button_outlet, state: false)
    
    changeDeadlineDate(sender, days: 30)
  }
  
  func changeDeadlineDate(_ sender: Any, days new_deadline_days: Int) {
    // ボタンとして叩かれた場合のみ期限を設定する
    if sender is UIButton {
      
      if let today_date_wrd = today_date, let calendar_wrd = calendar {
        // 期限を現在の日付 + 期限日付にする
        deadline_days = new_deadline_days
        let new_deadline_date = calendar_wrd.date(byAdding: .day, value: new_deadline_days, to: today_date_wrd)
        
        // 期限日付をpickerに設定する
        dateSettingPicker.date = new_deadline_date ?? Date()
      }
    }
  }
  
  
  
  // ボタンの見た目・活性不活性を変える関数
  // state:true=>活性 state:false=>不活性
  func changeButtonState(button: UIButton, state: Bool){
    button.isEnabled = state

    // もしstateがtrueなら色を灰色にして、活性にする
    if state {
      button.backgroundColor = UIColor.gray
    }
    // もしstateがfalseなら色を白色にして、不活性にする
    else {
      button.backgroundColor = UIColor.white
    }
  }
}

// アラームタイムと期限時刻からDateComponentsを返す関数
func returnDateComponentsforNotification(calendar cal: Calendar, deadline_date d_date: Date, alarm_time a_time: Date) ->DateComponents {
  return DateComponents(year: cal.component(.year, from: d_date), month: cal.component(.month, from: d_date), day: cal.component(.day, from: d_date),
                 hour: cal.component(.hour, from: a_time), minute: cal.component(.minute, from: a_time))
}


// ローカル通知を設定する関数
func setLocalNotification(_ date: DateComponents) {
  // UNMutableNotificationContent 作成
  let content = UNMutableNotificationContent()
  content.title = "コンタクトアラート"
  content.body = "コンタクトの期限がきました"
  content.sound = .default()
  
  deleteLocalNotification("ContactNotification")
  
  // UNTimeIntervalNotificationTrigger 作成、
  let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
  
  // identifier, content, trigger から UNNotificationRequest 作成
  let request = UNNotificationRequest(identifier: "ContactNotification", content: content, trigger: trigger)
  
  // UNUserNotificationCenter に request を追加
  let center = UNUserNotificationCenter.current()
  center.add(request) {
    (error) in
    if let theError = error {
      print(theError)
    }
  }
}

// ローカル通知を削除する関数
func deleteLocalNotification(_ identifier: String) {
  // UNUserNotificationCenter に request を追加
  let center = UNUserNotificationCenter.current()
  center.removePendingNotificationRequests(withIdentifiers: [identifier])
  
  //通知済みだが、通知を消していない通知を削除
  center.removeDeliveredNotifications(withIdentifiers: [identifier])
}
