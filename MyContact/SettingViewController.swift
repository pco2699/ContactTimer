//
//  SettingViewController.swift
//  MyContact
//
//  Created by pco2699 on 2017/06/07.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
  
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
  
  override func viewDidAppear(_ animated: Bool) {
    // UserDefaulsのインスタンスを生成
    let settings = UserDefaults.standard
    
    // UserDefaultsからデータを取得
    let deadline_date = settings.object(forKey: "deadline_date") as? Date
    // var deadline_days = settings.integer(forKey: "deadline_days")
    
    dateSettingPicker.date = deadline_date!
  }
  
}
