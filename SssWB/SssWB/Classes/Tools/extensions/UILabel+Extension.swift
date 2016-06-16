//
//  UILabel+Extension.swift
//  SssWB
//
//  Created by 闫波 on 16/5/25.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

extension UILabel {
    ///  便利构造函数
    ///
    ///  - parameter title:         字符串
    ///  - parameter color:         颜色
    ///  - parameter fontSize:      字体大小
    ///  - parameter layoutWidth:   布局宽度
    convenience init(title:String?,color:UIColor , fontSize:CGFloat ,layoutWidth:CGFloat = 0){
        self.init()
        text = title
        textColor = color
        font = UIFont.systemFontOfSize(fontSize)
        
        if layoutWidth > 0 {
            preferredMaxLayoutWidth = layoutWidth
            numberOfLines = 0
        }
        sizeToFit()
    }
}