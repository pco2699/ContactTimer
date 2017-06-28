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
    
    self.layer.backgroundColor = UIColor.buttonColor.cgColor
    
    // ボタンのボーダーを白にする
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

extension UIColor {
  class var buttonColor: UIColor { return #colorLiteral(red: 0.270554781, green: 0.2706074715, blue: 0.2705514729, alpha: 1) }
  class var statusBar : UIColor { return #colorLiteral(red: 0.09410236031, green: 0.09412645549, blue: 0.09410081059, alpha: 1) }
}
