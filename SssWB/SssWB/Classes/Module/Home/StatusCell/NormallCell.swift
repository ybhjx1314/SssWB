//
//  NormallCell.swift
//  SssWB
//
//  Created by yanbo on 16/5/27.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class NormallCell: StatusCell {

    override func setupUI() {
        super.setupUI()
        backgroundColor = UIColor.whiteColor()
        /// 图片
        let cons = pictureView.zz_AlignVertical(type: zz_LocationType.LeftButtom, referView: contentLabel, size: CGSizeMake(pictureItemMaxWidth, pictureItemMaxWidth), offset: CGPointMake(0, statusTopViewMargin))
        picHeightCons = pictureView.zz_Constraint(cons, attribute: NSLayoutAttribute.Height)
        picWidthCons = pictureView.zz_Constraint(cons, attribute: NSLayoutAttribute.Width)
        picTopCons = pictureView.zz_Constraint(cons, attribute: NSLayoutAttribute.Top)

    }

}
