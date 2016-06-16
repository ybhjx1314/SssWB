//
//  NewFeatureVC.swift
//  SssWB
//
//  Created by 闫波 on 16/5/23.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

private let NewFeatureCellID = "NewFeatureCellID"
private let NewFeatureCount = 4



class NewFeatureVC: UICollectionViewController {

    init (){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        // Register cell classes
        self.collectionView!.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: NewFeatureCellID)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ///  设置布局 本应该设置一次 兼容低版本 8.1 系统 view的frame有问题 不过新特性只会出现一次 影响不大
        setLayout()
    }
    
    private func setLayout(){
        /// 获得当前的布局
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        // item的大小
        layout.itemSize = view.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        // item的滚动方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return NewFeatureCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NewFeatureCellID, forIndexPath: indexPath) as! NewFeatureCell
        /// indexPath.row == indexPath.item
        cell.imageIndex = indexPath.item
    
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        /// 取出当前可见的cell
        let path = collectionView.indexPathsForVisibleItems().last!
        
        if path.item == NewFeatureCount - 1 {
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewFeatureCell
            
            cell.showStartButton()
        }
        
    }
    

}
/// 新特性cell
private class NewFeatureCell :UICollectionViewCell {
    /// 图像索引
    var imageIndex :Int = 0 {
        didSet{
            //TODO:  设置cell
            iconImage.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            startButton.hidden = true
        }
    }
    
    private func showStartButton(){
        startButton.hidden = false
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: [], animations: { 
                self.startButton.transform = CGAffineTransformIdentity
            }) { (_) in
                
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    @objc func startButtonClick(){
        printLog("adsdsads");
        NSNotificationCenter.defaultCenter() .postNotificationName(KSwitchRootViewControllerNoti, object: nil)
    }
    
    ///  1.添加控件
    private func setupUI(){
        
        addSubview(iconImage)
        addSubview(startButton)
        ///  2.设置位置
        iconImage.frame = bounds
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
//        let par = ["view":self];
        
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H", options: nil, metrics: <#T##[String : AnyObject]?#>, views: <#T##[String : AnyObject]#>))

        addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -160))
            
        printLog(bounds)
    }
    // MARK: - 懒加载
    private lazy var iconImage = UIImageView()
    
    private lazy var startButton : UIButton = {
        let button = UIButton()
        button.setTitle("开始体验", forState: .Normal)
        button.setBackgroundImage(UIImage(named:"new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        button.setBackgroundImage(UIImage(named:"new_feature_finish_button"), forState: UIControlState.Normal)
        
        button.sizeToFit()
        
        button.addTarget(self, action:#selector(NewFeatureCell.startButtonClick) , forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
}

