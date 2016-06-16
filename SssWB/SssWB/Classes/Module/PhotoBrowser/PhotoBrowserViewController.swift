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
    
    // MARK: - 设置界面
    override func loadView() {
        let rect = UIScreen.mainScreen().bounds
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
        // 2. 自动布局
        collectionView.frame = view.bounds
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDict = ["sa":saveButton,"cl":closeBtn]
        // 水平方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[cl(80)]-(>=8)-[sa(80)]-8-|", options: [], metrics: nil, views: viewDict))
        // 垂直方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cl(35)]-8-|", options: [], metrics: nil, views: viewDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sa(35)]-8-|", options: [], metrics: nil, views: viewDict))
        
        prepareCollectionView()
        
        // 3 监听方法
        
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
    
    // MARK: - 懒加载控件
    /// 照片查看视图
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    ///  保存按钮
    private lazy var saveButton :UIButton = UIButton(title: "保存", fontSize: 14)
    
    ///  关闭按钮
    private lazy var closeBtn : UIButton = UIButton(title: "关闭", fontSize: 14)
    
}

extension PhotoBrowserViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellID, forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    
}
