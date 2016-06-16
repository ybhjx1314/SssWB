//
//  UIColor+Extension.swift
//  SssWB
//
//  Created by yanbo on 16/6/15.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit


extension UIColor {
    
    class func randomColor() -> UIColor {
        
        let r = CGFloat( random() % 256) / 255
        let g = CGFloat( random() % 256) / 255
        let b = CGFloat( random() % 256) / 255
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
}