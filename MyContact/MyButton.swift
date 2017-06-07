//
//  MyButton.swift
//  MyContact
//
//  Created by pco2699 on 2017/06/05.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import UIKit

class MyButton: UIButton {
  override func draw(_ rect: CGRect) {
    // radiusの周りをマスクする
    self.layer.masksToBounds = true
    // ボタンを丸くする
    self.layer.cornerRadius = 50
    
    self.layer.borderColor = UIColor.black.cgColor
    self.layer.borderWidth =  1
  }
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  
}
