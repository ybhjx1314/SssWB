//
//  StatusPictureView.swift
//  SssWB
//
//  Created by yanbo on 16/5/26.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
import SDWebImage
/// 重用标示符
private let collectionViewCellID = "collectionViewCellID"

/// 选中照片通知
let HMStatusPictureViewSelectedPhotoNotification = "HMStatusPictureViewSelectedPhotoNotification"
/// 选中索引 Key
let HMStatusPictureViewSelectedPhotoIndexPathKey = "HMStatusPictureViewSelectedPhotoIndexPathKey"
/// 选中的图片 URL Key
let HMStatusPictureViewSelectedPhotoURLsKey = "HMStatusPictureViewSelectedPhotoURLsKey"


/// 图片视图
class StatusPictureView: UICollectionView {
    /// model
    var statusViewModel :StatusViewModel? {
        didSet{
            sizeToFit()
            
            reloadData()
        }
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return calcSize()
    }
    
    ///  计算大小
    ///
    ///  - returns: 大小
    private func calcSize() ->CGSize{
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = CGSizeMake(pictureItemWidth, pictureItemWidth)
        
        let count = statusViewModel?.thumbnailURLs?.count ?? 0
        
        if count == 0 {
            return CGSizeZero
        }
        
        if count == 1 {
            //TODO: 临时返回一个
            var size = CGSizeMake(150, 150)
            let key = statusViewModel?.thumbnailURLs![0].absoluteString
            ///  通过key 获取缓存图片
            if let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key) {
                size = image.size
            }
            
            size.width = size.width < 40 ? 40 : size.width
            size.width = size.width > 300 ? 300 :size.width
            
            layout.itemSize = size
            
            return size
        }
        
        if count == 4 {
            let w = 2 * pictureItemWidth  + pictureItemMargin
            return CGSizeMake(w, w)
        }
        // 2 ,3 ->1 5,6 -> 2 7 8 9 -> 3 最多9张
        let row = CGFloat((count - 1) / Int(pictureItenMaxCount) + 1)
        
        let h = CGFloat(row * pictureItemWidth + (row - 1) * pictureItemMargin)
        
        let w = pictureItemMaxWidth
        
        return CGSizeMake(w, h)
    }
    
    // MARK: - 实例化方法
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        backgroundColor = UIColor.whiteColor()
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = pictureItemMargin
        layout.minimumInteritemSpacing = pictureItemMargin
        
        registerClass(StatusPictureViewCell.self, forCellWithReuseIdentifier: collectionViewCellID)
        
        dataSource = self
        delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension StatusPictureView : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        print(cell?.frame)
        
        
        // 发送通知
        /**
         object: 发送的对象，可以传递一个数值，也可以是`自己`，通过 obj.属性
         userInfo: 可选字典，可以传递多个数值，object 必须有值
         */
        NSNotificationCenter.defaultCenter().postNotificationName(HMStatusPictureViewSelectedPhotoNotification,object: self,
                                                        userInfo:[HMStatusPictureViewSelectedPhotoIndexPathKey: indexPath,
                                                                    HMStatusPictureViewSelectedPhotoURLsKey: statusViewModel!.bmiddleURLs!])
    }
    // 根据index拿到 对应位置在屏幕上的 大小
    func screenRect(indexPath:NSIndexPath) -> CGRect {
        let cell = cellForItemAtIndexPath(indexPath)
        
        return  convertRect(cell!.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
    }
    
    // 根据index拿到 对应位置在父视图上的 大小
    func fullScreenRect(indexPath:NSIndexPath) -> CGRect{
        
        // 1 根据 拿到缩略图
        let path = statusViewModel!.bmiddleURLs![indexPath.item].absoluteString
        let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(path)
        
        if image == nil {
            return CGRectZero;
        }
        
        // 2 根据图算比例
        
        // 2.1 计算比例
        let scale = image.size.height / image.size.width
        let w = UIScreen.mainScreen().bounds.width
        let h = w * scale
        
        // 3 判断高度
        var y = (UIScreen.mainScreen().bounds.height - h) * 0.5
        if y < 0 {
            // 图片高于屏幕 则置顶图片
            y = 0
        }
        
        
        return CGRect(x: 0, y: y, width: w, height: h)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statusViewModel?.thumbnailURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionViewCellID, forIndexPath: indexPath) as! StatusPictureViewCell
        cell.imageURL = self.statusViewModel!.thumbnailURLs![indexPath.item]
        
        return cell
        
    }
    
}


/// 显示图片cell
private class StatusPictureViewCell :UICollectionViewCell {
    
    /// 配图视图的 URL
    var imageURL: NSURL? {
        didSet {
            iconView.sd_setImageWithURL(imageURL)
            
            gitImageView.hidden = (imageURL!.absoluteString as NSString).pathExtension.lowercaseString != "gif"
            
        }
    }
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconView)
        iconView.addSubview(gitImageView)
        
        
        iconView.zz_fill(self)
        gitImageView.zz_AlignInner(type: zz_LocationType.RightButtom, referView: iconView, size: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载
    private lazy var iconView: UIImageView = {
       
        let iv = UIImageView()
        /// 图片自动填充
        iv.contentMode = UIViewContentMode.ScaleAspectFill
        // 图片裁剪
        iv.clipsToBounds = true
        
        return iv
    }()
    
    /// 动态图标志
    private lazy var gitImageView : UIImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
    

    
}


