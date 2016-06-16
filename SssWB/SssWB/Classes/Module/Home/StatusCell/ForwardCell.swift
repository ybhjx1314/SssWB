//
//  ForwardCell.swift
//  SssWB
//
//  Created by yanbo on 16/5/27.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class ForwardCell: StatusCell {
    
    override var statusViewModel: StatusViewModel?{
        didSet{
            forwordLabel.text = statusViewModel?.forwordText
        }
    }
    
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = UIColor.whiteColor()
        ///  插入试图函数 below-> 着这个视图的下边
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.insertSubview(forwordLabel, aboveSubview: backButton)
        
        backButton.zz_AlignVertical(type: zz_LocationType.LeftButtom, referView: contentLabel, size: nil, offset: CGPoint(x: -statusTopViewMargin, y: statusTopViewMargin))
        backButton.zz_AlignVertical(type: zz_LocationType.RightTop, referView: bottomView, size: nil)
        
        forwordLabel.zz_AlignInner(type: zz_LocationType.LeftTop, referView: backButton, size: nil, offset: CGPoint(x: statusTopViewMargin, y: statusTopViewMargin))
        
        /// 图片
        let cons = pictureView.zz_AlignVertical(type: zz_LocationType.LeftButtom, referView: forwordLabel, size: CGSizeMake(pictureItemMaxWidth, pictureItemMaxWidth), offset: CGPointMake(0, statusTopViewMargin))
        picHeightCons = pictureView.zz_Constraint(cons, attribute: NSLayoutAttribute.Height)
        picWidthCons = pictureView.zz_Constraint(cons, attribute: NSLayoutAttribute.Width)
        picTopCons = pictureView.zz_Constraint(cons, attribute: NSLayoutAttribute.Top)
        
        
    }

    // MARK: - 懒加载控件
    /// 背景按钮
    private lazy var backButton :UIButton = {
       
        let btn = UIButton()
        
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        return btn
        
    }()
    ///  文字Label
    private lazy var forwordLabel :UILabel = UILabel(title: "转发微博", color: UIColor.darkGrayColor(), fontSize: 14,layoutWidth: UIScreen.mainScreen().bounds.width - 2 * statusTopViewMargin)
    
    
}
