//
//  StatusCellBottomView.swift
//  SssWB
//
//  Created by yanbo on 16/5/25.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class StatusCellBottomView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        /// 添加控件
        addSubview(forwardBtn)
        addSubview(commBtn)
        addSubview(likeBtn)
        
        /// 设置约束
        
        zz_HorizontalTile([forwardBtn,commBtn,likeBtn], insets: UIEdgeInsetsZero)
        
    }
    /// 转发按钮
    private lazy var forwardBtn : UIButton = UIButton(title: " 转发", imageName: "timeline_icon_retweet", fontSize: 12, color: UIColor.darkGrayColor())
    /// 评论
    private lazy var commBtn : UIButton = UIButton(title: " 评论", imageName: "timeline_icon_comment", fontSize: 12, color: UIColor.darkGrayColor())
    /// 点赞
    private lazy var likeBtn : UIButton = UIButton(title: " 赞", imageName: "timeline_icon_unlike", fontSize: 12, color: UIColor.darkGrayColor())
    
}
