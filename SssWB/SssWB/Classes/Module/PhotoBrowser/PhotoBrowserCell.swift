//
//  PhotoBrowserCell.swift
//  SssWB
//
//  Created by yanbo on 16/6/15.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
import SDWebImage


class PhotoBrowserCell: UICollectionViewCell {
    
    var url : NSURL? {
        didSet {
            imageView.sd_setImageWithURL(url, placeholderImage: nil, options: [SDWebImageOptions.RetryFailed]) { (image, error, _, _) in
                    self.imageView.sizeToFit()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///  设置界面
    private func setupUI(){
        // 1. 添加控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        // 2. 设置约束
        scrollView.frame = bounds
        
        
    }
    
    /// 滚动试图
    private lazy var scrollView : UIScrollView = UIScrollView()
    
    ///  单张图片
    private lazy var imageView : UIImageView = UIImageView()
    
}
