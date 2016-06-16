//
//  UIBarButtonItem+Extension.swift
//  SssWB
//
//  Created by yanbo on 16/5/31.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    ///  便利构造函数
    ///
    ///  - parameter imageName:  imageName
    ///  - parameter target:     target
    ///  - parameter actionName: actionName
    ///
    ///  - returns: UIBarButtonItem
    convenience init(imageName:String ,target:AnyObject?,actionName:String?) {
        let button = UIButton(imageName: imageName)
        
        if  target != nil && actionName != nil {
            button.addTarget(target, action: Selector(actionName!), forControlEvents: UIControlEvents.TouchUpInside)
        }
        self.init(customView:button)
    }
    
}