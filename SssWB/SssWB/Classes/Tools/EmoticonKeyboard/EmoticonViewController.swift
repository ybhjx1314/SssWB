//
//  EmoticnViewController.swift
//  emoticonkeyboard
//
//  Created by yanbo on 16/6/2.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

/// 标识符
private let EmoticonViewCellID = "EmoticonViewCellID"

/// 表情控制器
class EmoticonViewController: UIViewController {
    
    var selectedEmoticonBlock:(emoticon:Emoticon)->()
    
    init(selectedEmoticon:(emoticon:(Emoticon)) -> ()) {
        
        selectedEmoticonBlock = selectedEmoticon
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 监听方法
    @objc private func itemClick(item:UIBarButtonItem){
        print(item.tag)
        let indexPath = NSIndexPath(forRow: 0, inSection: item.tag)
        
        collectioniew.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.lightGrayColor()
        
        setupUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        print(view)
    }

    // MARK: - 搭建界面
    private func setupUI(){
        //1 添加视图
        view.addSubview(collectioniew)
        view.addSubview(toolbar)
        
        //2 设置约束
        collectioniew.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDict = ["tb":toolbar,"cv":collectioniew]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: [], metrics: nil, views: viewDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tb]-0-|", options: [], metrics: nil, views: viewDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-[tb(44)]-0-|", options: [], metrics: nil, views: viewDict))
        
        //3 准备控件
        createToolbar()
        createCollectionView()
        
        
        
    }
    ///  创建工具栏
    private func createToolbar(){
        toolbar.tintColor = UIColor.darkGrayColor()
        var items = [UIBarButtonItem]()
        var index = 0
        for package in viewModel.packages {
            
            items.append(UIBarButtonItem(title: package.group_name_cn, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EmoticonViewController.itemClick(_:)) ))
            
            items.last?.tag = index
            index += 1
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
            
        }
        items.removeLast()
        toolbar.items = items
    }
    /// 创建图片
    private func createCollectionView(){
        /// 创建视图
        collectioniew.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: EmoticonViewCellID)
        // 代理
        collectioniew.dataSource = self
        collectioniew.delegate = self
        collectioniew.backgroundColor = UIColor.whiteColor()
    }
    
    /// 键盘底部的
    private lazy var toolbar : UIToolbar = UIToolbar()
    ///  collectionview
    private lazy var collectioniew : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonLayout())
    /// 视图模型
    private lazy var viewModel = EmoticonViewModel()
    
    
}
// MARK: - Layout
private class EmoticonLayout : UICollectionViewFlowLayout{
    private override func prepareLayout() {
        super.prepareLayout()
//        print(collectionView)
        
        
        /// 每个item的宽
        let w = collectionView!.bounds.width / 7
        /// 上下间距
        let margin = (collectionView!.bounds.height - (3 * w)) * 0.499
        collectionView?.bounces = false
        sectionInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
        
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        
        itemSize = CGSizeMake(w, w)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        
    }
    
}

// MARK: - UICollectionViewDataSource
extension EmoticonViewController : UICollectionViewDataSource , UICollectionViewDelegate{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.packages.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.packages[section].emoticons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectioniew.dequeueReusableCellWithReuseIdentifier(EmoticonViewCellID, forIndexPath: indexPath) as! EmoticonCell
        
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.orangeColor() : UIColor.brownColor()
        
        cell.emoticon = viewModel.emoticon(indexPath)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedEmoticonBlock(emoticon: viewModel.emoticon(indexPath))
        viewModel.favorite(indexPath)
    }
    
}

// MARK: - 表情cell
private class EmoticonCell : UICollectionViewCell{
    
    var emoticon : Emoticon? {
        didSet {
//            print(emoticon?.imagePath)
            let img = UIImage(contentsOfFile: emoticon!.imagePath)
            emoticonBtn.setImage(img, forState: .Normal)
            emoticonBtn.setTitle(emoticon?.emoji, forState: UIControlState.Normal)
            
            if emoticon!.isRemove {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: .Highlighted)
            }
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emoticonBtn)
        emoticonBtn.backgroundColor = UIColor.whiteColor()
        emoticonBtn.frame = CGRectInset(bounds, 4, 4)
        emoticonBtn.titleLabel?.font = UIFont.systemFontOfSize(32)
        emoticonBtn.userInteractionEnabled = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 懒加载控件
    private lazy var emoticonBtn : UIButton = UIButton()
}





