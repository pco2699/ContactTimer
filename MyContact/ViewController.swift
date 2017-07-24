//
//  ViewController.swift
//  MyContact
//
//  Created by pco2699 on 2017/06/05.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
  // 期限を設定する変数を設定
  var deadline_date : Date?
  // 現在の日にちを変数に設定
  var today_date : Date?
  // コンタクトの期限日数を設定
  var deadline_days : Int?
  // カレンダーを保持する変数
  var calendar: Calendar?
  

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // current() メソッドを使用してシングルトンオブジェクトを取得
    let center = UNUserNotificationCenter.current()
    
    // 通知の使用許可をリクエスト
    center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
      // Enable or disable features based on authorization.
      if !granted {
        //許可が得られなかったので確認表示を行う
        let controller = UIAlertController(title: "確認", message: "通知を許可する場合には「設定＞通知」にてオンにする設定をしてください", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(controller, animated: true, completion: nil)
      }
    }
    
    // UserDefaulsのインスタンスを生成
    let settings = UserDefaults.standard
    
    // UserDefaultsからデータを取得
    deadline_date = settings.object(forKey: "deadline_date") as? Date
    deadline_days = settings.integer(forKey: "deadline_days")
    
    // 西暦対応するため gregorianに設定
    calendar = Calendar(identifier: .gregorian)
    
    // 現在の日付のDate型を取得
    today_date = Date()

    // もしUserDefaultsからデータを取得できなかった場合、初期値登録
    if deadline_date == nil {
      deadline_days = 14
      deadline_date = calendar?.date(byAdding: .day, value: deadline_days!, to: today_date!)
      let alarm_time = calendar?.date(from: DateComponents(hour: 07, minute: 00, second: 00))
      
      // UserDefaultsに初期値を登録
      settings.register(defaults: ["deadline_date": deadline_date!, "deadline_days": deadline_days!, "alarm_time": alarm_time!, "alarm_switch_state": false])
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    // 現在の日付のDate型を取得
    today_date = Date()
    
    // UserDefaulsのインスタンスを生成
    let settings = UserDefaults.standard
    
    // UserDefaultsからコンタクトの期限を取得
    deadline_date = settings.object(forKey: "deadline_date") as? Date
    deadline_days = settings.integer(forKey: "deadline_days")
    
    // 現在の残り日数を計算
    var deadline_days_now = calendar?.dateComponents([.day], from: roundDate(today_date!, calendar: calendar!), to: roundDate(deadline_date!, calendar: calendar!)).day
    
    // 0日以下だったら0に設定
    if deadline_days_now! < 0 {
      deadline_days_now = 0
    }
    
    daysLabel.text = deadline_days_now?.description
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @IBOutlet weak var daysLabel: UILabel!
  
  @IBAction func resetButtonAction(_ sender: Any) {
    // deadline_dateをdeadline_daysを加算する。
    deadline_date = calendar?.date(byAdding: .day, value: deadline_days!, to: today_date!)
    
    // UserDefaultsを呼び出し
    let settings = UserDefaults.standard
    
    // alarm timeを取得
    let alarm_time = settings.object(forKey: "alarm_time") as? Date
    
    // switchがonかどうかを取得
    let alarm_switch = settings.bool(forKey: "alarm_switch_state")
    
    
    // ラベルを設定
    daysLabel.text = deadline_days?.description
    
    if alarm_switch {
      // Notificationの再設定
      if let cal = calendar, let d_date = deadline_date, let a_time = alarm_time {
        let settingDate = returnDateComponentsforNotification(calendar: cal, deadline_date: d_date, alarm_time: a_time)
        setLocalNotification(settingDate)
      }
    }
    
    // UserDefaultsに次の日程を設定
    settings.setValue(deadline_date, forKey: "deadline_date")
    settings.synchronize()
  }

  @IBAction func settingButtonAction(_ sender: Any) {
    // 設定画面へ画面遷移
    performSegue(withIdentifier: "goSetting", sender: nil)
  }
  
  // Dateから年日月を抽出する関数
  func roundDate(_ date: Date, calendar cal: Calendar) -> Date {
    return cal.date(from: DateComponents(year: cal.component(.year, from: date), month: cal.component(.month, from: date), day: cal.component(.day, from: date)))!
  }
}

