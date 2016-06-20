//
//  PhotoBrowserViewController.swift
//  Weibo09
//
//  Created by Romeo on 15/9/14.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit
import SVProgressHUD

private let PhotoBrowserCellID = "PhotoBrowserCellID"

class PhotoBrowserViewController: UIViewController {

    var urls :[NSURL]
    var selectedIndexPath : NSIndexPath
    
    var currentImageIndexPath : NSIndexPath {
        return collectionView.indexPathsForVisibleItems().last!
    }
    
    var currentImageView : UIImageView {
        let cell = collectionView.cellForItemAtIndexPath(currentImageIndexPath) as! PhotoBrowserCell
        return cell.imageView
    }
    
    // MARK: - 保存图片
    
    @objc func saveImage(){
        // 1 拿到图片
        guard let image = currentImageView.image else {
            SVProgressHUD.showWithStatus("你麻痹,网络不给力")
            return
        }
        // 2 保存图像
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        
    }
//    - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    @objc private func image(image:UIImage ,didFinishSavingWithError error:NSError?,contextInfo : AnyObject){
        printLog("OK ========== OK")
        
        let msg = (error == nil) ? "保存成功" : "保存失败"
        
        SVProgressHUD.showInfoWithStatus(msg)
    }
    
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
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[cl(80)]-(>=8)-[sa(80)]-28-|", options: [], metrics: nil, views: viewDict))
        // 垂直方向
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cl(35)]-8-|", options: [], metrics: nil, views: viewDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sa(35)]-8-|", options: [], metrics: nil, views: viewDict))
        
        view.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: -10))
        view.addConstraint(NSLayoutConstraint(item: pageControl, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -8))
        
        prepareCollectionView()
        preparePageControl()
        // 3 监听方法
        ///  关闭按钮
        closeBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { [weak self] (btn) in
            
            self?.dismissViewControllerAnimated(true, completion: {
                
            })
        }
        ///  保存图片
        saveButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext { [weak self] (btn) in
            
            self?.saveImage()
        }
        pageControl.rac_signalForControlEvents(.ValueChanged).subscribeNext {[weak self] (control) in
            let indexPath = NSIndexPath(forItem: control.currentPage, inSection: 0)
            
            self?.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
            
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
    /// 照片缩放比例 - Swift 的 extension 中不能包含存储型属性
    private var photoScale: CGFloat = 1
   
    
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
        cell.url = urls[indexPath.item]
        cell.photoDelegate = self
        return cell
    }
    
}
// MARK: - UIViewControllerInteractiveTransitioning - 交互式转场协议
extension PhotoBrowserViewController: UIViewControllerInteractiveTransitioning {
    
    /// 开始交互转场
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        view.transform = CGAffineTransformMakeScale(photoScale, photoScale)
        view.alpha = photoScale
    }
}
extension PhotoBrowserViewController :PhotoBrowserCellDelegate{
    /// 完成缩放
    func photoBrowserCellEndZoom() {
        print("\(photoScale)")
        if photoScale < 0.8 {
            completeTransition(true)
        } else {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.view.transform = CGAffineTransformIdentity
                self.view.alpha = 1.0
                }, completion: { (_) in
                    self.hideControllers(false)
            })
        }
    }
    
    /// 照片视图缩放
    func photoBrowserCellDidZoom(scale: CGFloat) {
        // 记录缩放比例
        print(scale)
        photoScale = scale
        hideControllers(scale < 1.0)
        
        if scale < 1.0 {
            startInteractiveTransition(self)
        } else {
            view.transform = CGAffineTransformIdentity
            view.alpha = 1.0
        }
    }
    
    private func hideControllers(isHidden:Bool){
        closeBtn.hidden = isHidden
        saveButton.hidden = isHidden
        pageControl.hidden = (urls.count == 1) ? true :  isHidden
        
        view.backgroundColor = isHidden ? UIColor.clearColor() : UIColor.blackColor()
        collectionView.backgroundColor = isHidden ? UIColor.clearColor() : UIColor.blackColor()
        
    }
}

// MARK: - UIViewControllerContextTransitioning - 转场上下文协议
extension PhotoBrowserViewController: UIViewControllerContextTransitioning {
    
    /// 完成转场
    func completeTransition(didComplete: Bool) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 容器视图
    func containerView() -> UIView? { return view.superview }
    
    func isAnimated() -> Bool { return true }
    func isInteractive() -> Bool { return true }
    func transitionWasCancelled() -> Bool { return false }
    func presentationStyle() -> UIModalPresentationStyle { return UIModalPresentationStyle.Custom }
    
    func updateInteractiveTransition(percentComplete: CGFloat) {}
    func finishInteractiveTransition() {}
    func cancelInteractiveTransition() {}
    
    func viewControllerForKey(key: String) -> UIViewController? { return nil }
    func viewForKey(key: String) -> UIView? { return nil }
    func targetTransform() -> CGAffineTransform { return CGAffineTransformIdentity }
    
    func initialFrameForViewController(vc: UIViewController) -> CGRect { return CGRectZero }
    func finalFrameForViewController(vc: UIViewController) -> CGRect { return CGRectZero }
}

