//
//  StatusCellTopView.swift
//  SssWB
//
//  Created by yanbo on 16/5/25.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
import SDWebImage




class StatusCellTopView: UIView {

    var statusViewModel : StatusViewModel? {
        didSet{
            //TODO: 数据处理中
            nameLabel.text = statusViewModel?.status.user?.name
            iconView.sd_setImageWithURL(statusViewModel?.iconUrl)
            vipImageView.image = statusViewModel?.vipImage
            memImageView.image = statusViewModel?.mbRankImage
            //TODO: 处理 时间格式
            print(statusViewModel?.status.created_at)
            print(NSDate.sinaDate(statusViewModel!.status.created_at!))
//            timeLabel.text = statusViewModel?.status.created_at
//            fromLabel.text = statusViewModel?.status.source
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        backgroundColor = UIColor.whiteColor()
        ///  1 添加控件
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(memImageView)
        addSubview(timeLabel)
        addSubview(fromLabel)
        addSubview(vipImageView)
        ///  2 自动布局
        let offset = CGPoint(x: statusTopViewMargin, y: 0)
        iconView.zz_AlignInner(type: zz_LocationType.LeftTop, referView: self, size:CGSizeMake(statusTopIconW , statusTopIconW), offset: CGPoint(x: statusTopViewMargin, y: statusTopViewMargin))
        nameLabel.zz_AlignHorizontal(type: zz_LocationType.RightTop, referView: iconView, size: nil, offset: offset)
        memImageView.zz_AlignHorizontal(type: zz_LocationType.RightTop, referView: nameLabel, size: nil, offset: offset)
        timeLabel.zz_AlignHorizontal(type: zz_LocationType.RightButtom, referView: iconView, size: nil, offset: offset)
        fromLabel.zz_AlignHorizontal(type: zz_LocationType.RightButtom, referView: timeLabel, size: nil, offset: offset)
        vipImageView.zz_AlignInner(type: zz_LocationType.RightButtom, referView: iconView, size: nil, offset: CGPoint(x: 8, y: 8))
    }
     /// 头像
    private lazy var iconView : UIImageView = UIImageView(image: UIImage(named: "avatar_default_big"))
     /// 姓名
    private lazy var nameLabel : UILabel = UILabel(title: nil, color: UIColor.darkGrayColor(), fontSize: 14)
     /// 会员标识
    private lazy var memImageView : UIImageView = UIImageView(image: UIImage(named: "common_icon_membership_level1"))
    ///  时间
    private lazy var timeLabel :UILabel = UILabel(title: "刚刚", color: UIColor.orangeColor(), fontSize: 10)
     /// 来源
    private lazy var fromLabel :UILabel = UILabel(title: "来自 新浪", color: UIColor.darkGrayColor(), fontSize: 10)
    ///  Vip
    private lazy var vipImageView :UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    
}
