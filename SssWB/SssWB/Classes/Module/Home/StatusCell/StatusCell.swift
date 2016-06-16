//
//  StatusCell.swift
//  SssWB
//
//  Created by yanbo on 16/5/25.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
/// 微博cell的头试图间距
let statusTopViewMargin :   CGFloat = 12
/// 微博cell头像的宽
let statusTopIconW      :   CGFloat = 35
/// 图片默认宽
let pictureItemWidth    :   CGFloat = 90
/// 图片默认间距
let pictureItemMargin   :   CGFloat = 10
/// 图片最大个数
let pictureItenMaxCount :   CGFloat = 3

/// 图片最大宽度
let pictureItemMaxWidth :   CGFloat = pictureItemWidth * pictureItenMaxCount + (pictureItenMaxCount - 1) * pictureItemMargin


/// 微博Cell
class StatusCell: UITableViewCell {
    
    var statusViewModel :StatusViewModel? {
        didSet{
            
            topView.statusViewModel = statusViewModel
            contentLabel.text = statusViewModel?.status.text
            picWidthCons?.constant = pictureItemWidth
            
            pictureView.statusViewModel = statusViewModel
            
            picHeightCons?.constant = pictureView.bounds.height
            picWidthCons?.constant = pictureView.bounds.width
            
            picTopCons?.constant = statusViewModel?.thumbnailURLs?.count == 0 ? 0 : statusTopViewMargin
            
        }
    }
    /// 图片高度
    var picHeightCons : NSLayoutConstraint?
    /// 图片宽度
    var picWidthCons :  NSLayoutConstraint?
    /// 图片上边约束
    var picTopCons :  NSLayoutConstraint?
    
    func rowHeight(viewModel:StatusViewModel) -> CGFloat {
        statusViewModel = viewModel
        
        layoutIfNeeded()
        
        return CGRectGetMaxY(bottomView.frame)
        
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///  添加UI
    func setupUI(){
        backgroundColor = UIColor.whiteColor()
        let topSepView = UIView()
        topSepView.backgroundColor = UIColor(white: 0.85, alpha: 1)
        /// 1. 添加控件
        contentView.addSubview(topSepView)
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        /// 2 设置位置
        let width = UIScreen.mainScreen().bounds.width
        
        // 1.分割视图
        topSepView.zz_AlignInner(type: zz_LocationType.LeftTop, referView: contentView, size: CGSizeMake(width, 10))
        
        /// 头试图
        topView.zz_AlignVertical(type: zz_LocationType.LeftButtom, referView: topSepView, size: CGSizeMake(width, statusTopViewMargin + statusTopIconW))
       
        /// 文字
        contentLabel.zz_AlignVertical(type: zz_LocationType.LeftButtom, referView: topView, size: nil, offset: CGPoint(x: statusTopViewMargin, y: statusTopViewMargin))
        
        /// 按钮
        bottomView.zz_AlignVertical(type: zz_LocationType.LeftButtom, referView: pictureView, size: CGSizeMake(width, 44), offset: CGPoint(x: -statusTopViewMargin, y: statusTopViewMargin))
        
        /// 设置最后一个控件的约束
//        bottomView.zz_AlignInner(type: zz_LocationType.RightButtom, referView: contentView, size: nil)
    }
    
    
    // MARK: - 懒加载控件
    
    ///  1. 顶部试图
    private lazy var topView : StatusCellTopView = StatusCellTopView()
    ///  2. 中间文字
    lazy var contentLabel = UILabel(title: "", color: UIColor.darkGrayColor(), fontSize: 15 ,layoutWidth: UIScreen.mainScreen().bounds.width - 2 * statusTopViewMargin)
    ///  3. 图片
    lazy var pictureView : StatusPictureView = StatusPictureView()
    ///  4. 底部评论按钮
    lazy var bottomView :StatusCellBottomView = StatusCellBottomView()
    
    
}
