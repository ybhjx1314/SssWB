//
//  ProgressImageView.swift
//  SssWB
//
//  Created by yanbo on 16/6/20.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class ProgressImageView: UIImageView {
    /// 下载进度
    var progress :CGFloat = 0 {
        didSet{
            pgView.progress = progress
        }
        
    }
    
    private lazy var pgView:ProgressView = {
        let p = ProgressView()
        p.backgroundColor = UIColor.clearColor()
        p.frame = self.bounds
        
        self.addSubview(p)
        
        return p
        
    }()
    
    
    private class ProgressView:UIView {
        /// 下载进度
        var progress :CGFloat = 0 {
            didSet{
                setNeedsDisplay()
            }
        }
        
        override func drawRect(rect: CGRect) {
            printLog(progress)
            
            if progress >= 1 {
                return
            }
            
            // 绘制曲线
            // 1.中心点 2 半径 3 开始角度 4 结束角度 5 是否顺时针
            let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
            let r = min(rect.width , rect.height) * 0.5
            let start = -CGFloat(M_PI_2)
            let end = 2 * CGFloat(M_PI) * progress + start
            
            let path = UIBezierPath(arcCenter: center, radius: r, startAngle: start, endAngle: end, clockwise: true)
            
            path.addLineToPoint(center)
            path.closePath()
            
            /// 设置线宽
//            path.lineWidth = 10
            ///  设置画线颜色
//            UIColor.redColor().setStroke()
            ///  设置填充颜色
            UIColor(white: 0.0, alpha: 0.5).setFill()
            
            path.fill()
            
            
        }

    }
    
}
