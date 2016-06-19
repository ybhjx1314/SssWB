//
//  PhotoBrowserCell.swift
//  SssWB
//
//  Created by yanbo on 16/6/15.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class PhotoBrowserCell: UICollectionViewCell {
    
    var url : NSURL? {
        
        didSet {
            
            ///  重置scrollView
            resetScrollView()
            
            indicatorView.startAnimating()
            imageView.sd_setImageWithURL(url, placeholderImage: nil, options: [SDWebImageOptions.RetryFailed]) { (image, error, _, _) in
                
                self.indicatorView.stopAnimating()
                if error != nil {
                    SVProgressHUD.showWithStatus("你麻痹,网络不给力啊")
                    return
                }
                
                self.setImagePosition()
            }
        }
    }
    
    private func resetScrollView(){
        scrollView.contentSize = CGSizeZero
        scrollView.contentOffset = CGPointZero
        scrollView.contentInset = UIEdgeInsetsZero
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
        contentView.addSubview(indicatorView)
        // 2. 设置约束
        var rect = bounds
        rect.size.width -= 20
        scrollView.frame  = rect
        indicatorView.center = scrollView.center
        prepareScrollView()
    }
    
    private func prepareScrollView(){
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        
        
    }
    
    private func setImagePosition(){
        
        let size = displaySize(imageView.image!)
        
        imageView.frame = CGRect(origin: CGPointZero, size: size)
        if size.height < scrollView.bounds.height {
            let y = (scrollView.bounds.height - size.height) * 0.5
            
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
        } else {
            // 长图
            scrollView.contentSize = size
        }
        
    }
    
    ///  根据图像大小调整图像位置
    ///
    ///  - parameter image: 图片
    ///
    ///  - returns: 位置
    private func displaySize(image:UIImage) -> CGSize {
        // 图像宽高比
        let scale = image.size.height / image.size.width
        
        let w = scrollView.bounds.width
        
        let h = w * scale
        
        return CGSize(width: w, height: h)
        
    }
    
    
    /// 滚动试图
    private lazy var scrollView : UIScrollView = UIScrollView()
    
    ///  单张图片
    lazy var imageView : UIImageView = UIImageView()
    
    ///  指示器
    private lazy var indicatorView  = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
}
// MARK: - UIScrollViewDelegate
extension PhotoBrowserCell:UIScrollViewDelegate {
    // 缩放的试图
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        var offectY = (scrollView.bounds.height - imageView.frame.height) * 0.5
        var offectX = (scrollView.bounds.width - imageView.frame.width) * 0.5

        offectY = (offectY < 0) ? 0 : offectY
        offectX = (offectX < 0) ? 0 : offectX
//        let offectX = scrollView
        
        scrollView.contentInset = UIEdgeInsets(top: offectY
            , left: offectX, bottom: 0, right: 0 )
        
        print("--------------")
        print(scrollView.contentSize)
        
    }
    
}


