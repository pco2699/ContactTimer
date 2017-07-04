//
//  EditableButton.swift
//  MyContact
//
//  Created by pco2699 on 2017/06/28.
//  Copyright © 2017年 pco2699. All rights reserved.
//

import UIKit

class EditableButton: UIButton {
  
  /*
   // Only override draw() if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   override func draw(_ rect: CGRect) {
   // Drawing code
   }
   */
  var cornerRadius:CGFloat = 0.0
  var borderColor:UIColor = UIColor.clear
  var borderWidth:CGFloat = 0.0
  
  
  override func draw(_ rect: CGRect) {
    // radiusの周りをマスクする
    self.layer.masksToBounds = true
    
    self.layer.cornerRadius = self.cornerRadius
    self.layer.borderColor = self.borderColor.cgColor
    self.layer.borderWidth = self.borderWidth
    
    super.draw(rect)
  }
  
  
}
