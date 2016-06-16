//
//  UIButton+Extension.swift
//  SssWB
//
//  Created by yanbo on 16/5/26.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

extension UIButton {
    
    ///  便利构造函数
    ///
    ///  - parameter title:     标题
    ///  - parameter imageName: 图片名称
    ///  - parameter fontSize:  字体大小
    ///  - parameter color:     字体颜色
    convenience init(title:String,imageName:String,fontSize:CGFloat,color:UIColor){
        self.init()
        
        setTitle(title, forState: UIControlState.Normal)
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setTitleColor(color, forState: UIControlState.Normal )
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        
    }
    ///  便利构造函数
    ///
    ///  - parameter imageName: 图片名称
    convenience init(imageName:String){
        self.init()
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        sizeToFit()
    }
    ///  便利构造函数
    ///
    ///  - parameter title:     标题
    ///  - parameter fontSize:  字体大小
    ///  - parameter color:     字体颜色
    ///  - parameter backColor: 背景颜色
    ///
    ///  - returns: UIButton
    convenience init(title: String, fontSize: CGFloat ,color: UIColor = UIColor.whiteColor(), backColor:UIColor = UIColor.darkGrayColor()){
        self.init()
        
        setTitle(title, forState: .Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        
        setTitleColor(color, forState: .Normal)
        backgroundColor = backColor
        
    }
}
