//
//  UIStoryboard+Extension.swift
//  SssWB
//
//  Created by 闫波 on 16/6/22.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit


extension UIStoryboard {
    /// 返回storyboard的初始控制器
    class func initialViewController(name:String) -> UIViewController {
        let sb = UIStoryboard(name: name, bundle: nil)
        return sb.instantiateInitialViewController()!
    }
}