//
//  PhotoBrowserViewController.swift
//  Weibo09
//
//  Created by Romeo on 15/9/14.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit


private let PhotoBrowserCellID = "PhotoBrowserCellID"

class PhotoBrowserViewController: UIViewController {

    var urls :[NSURL]
    var selectedIndexPath : NSIndexPath
    
    
    init(urls:[NSURL],indexPath:NSIndexPath){
        self.urls = urls
        selectedIndexPath = indexPath
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printLog(urls as NSArray)
        printLog(selectedIndexPath)
        
    }
    ///  完成界面布局
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        /// 滚动到点击试图
        collectionView.scrollToItemAtIndexPath(selectedIndexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        pageControl.currentPage = selectedIndexPath.item
    }
    
    // MARK: - 设置界面
    override func loadView() {
        var rect = UIScreen.mainScreen().bounds
        rect.size.width += 20
        view = UIView(frame: rect)
        view.backgroundColor = UIColor.blackColor()
        
        // 界面
        setupUI()
        
    }
 
    
    ///  设置界面细节
    private func setupUI(){
        // 1. 添加控件
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        view.addSubview(closeBtn)
        view.addSubview(pageControl)
        // 2. 自动布局
        collectionView.frame = view.bounds
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDict = ["sa":saveButton,"cl":closeBtn]
        // 水平方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[cl(80)]-(>=8)-[sa(80)]-8-|", options: [], metrics: nil, views: viewDict))
        // 垂直方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cl(35)]-8-|", options: [], metrics: nil, views: viewDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sa(35)]-8-|", options: [], metrics: nil, views: viewDict))
        
        view.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -8))
        
        prepareCollectionView()
        preparePageControl()
        // 3 监听方法
        closeBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { [weak self](btn) in
            
            self?.dismissViewControllerAnimated(true, completion: {
                
            })
        }
    }
    
    ///  准备collectionview
    private func prepareCollectionView(){
        collectionView.registerClass(PhotoBrowserCell.self, forCellWithReuseIdentifier: PhotoBrowserCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = view.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView.pagingEnabled = true
        
    }
    
    private func preparePageControl(){
        pageControl.numberOfPages = urls.count
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = UIColor.redColor()
        
    }
    
    // MARK: - 懒加载控件
    /// 照片查看视图
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    ///  保存按钮
    private lazy var saveButton :UIButton = UIButton(title: "保存", fontSize: 14)
    ///  关闭按钮
    private lazy var closeBtn : UIButton = UIButton(title: "关闭", fontSize: 14)
    /// 分页控件
    private lazy var pageControl : UIPageControl = UIPageControl()
    
}

extension PhotoBrowserViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    // indexPath 是前一个cell的索引
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        pageControl.currentPage = collectionView.indexPathsForVisibleItems().last?.item ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellID, forIndexPath: indexPath) as! PhotoBrowserCell
        
        cell.backgroundColor = UIColor.blackColor()
        cell.url = urls[indexPath.item]
        return cell
    }
    
}
