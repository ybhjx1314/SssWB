//
//  UIImage+Extension.swift
//  PictureSelector
//
//  Created by yanbo on 16/6/2.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

extension UIImage{
    ///  缩放图片
    ///
    ///  - parameter width: 指定宽度
    ///
    ///  - returns: 缩小的图片
    func sacleImageToWidth(width:CGFloat) -> UIImage {
        if size.width < width {
            return self
        }
        // 2 计算图片宽高比
        let height = width * size.width / size.height
        
        // 3 图像上下文
        let s = CGSize(width: width, height: height)
        // 开始图像上下文 一旦开启上下文 所有的图像绘制都在当前上下文中
        UIGraphicsBeginImageContext(s)
        // 在指定区域中绘制图像
        drawInRect(CGRect(origin: CGPointZero, size: s))
        // 得到绘制结果
        let res = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return res
        
    }
}
