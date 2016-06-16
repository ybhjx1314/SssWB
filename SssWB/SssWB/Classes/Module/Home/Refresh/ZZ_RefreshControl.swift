//
//  ZZ_RefreshControl.swift
//  SssWB
//
//  Created by 闫波 on 16/5/28.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

let Max_Offset : CGFloat = -60
let LoadingAnimationKey = "loadingViewAnimation"

/// 刷新控制器
class ZZ_RefreshControl: UIRefreshControl {
    
    // MARK: - KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        
        if frame.origin.y > 0 {
            return
        }
        
        if refreshing {
            refreshView.loadingAnimate()
            return
        }
        
        if frame.origin.y < Max_Offset && !refreshView.rotateFlag {
            printLog("翻过来")
            refreshView.rotateFlag = true
        } else if frame.origin.y >= Max_Offset && refreshView.rotateFlag {
            printLog("转过去")
            refreshView.rotateFlag = false
        }
        
    }
    ///  重写end方法 停止动画
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopAnimation()
    }
    
    
    // MARK: - 实例化
    override init() {
        super.init()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        setupUI()
    }
    
    deinit{
        self.removeObserver(self, forKeyPath: "frame")
    }
    
    
    
    private func setupUI(){
        // MARK: - KVO
        self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        
        tintColor = UIColor.clearColor()
        
        addSubview(refreshView)
        
        refreshView.zz_AlignInner(type: zz_LocationType.CenterCenter, referView: self, size: refreshView.bounds.size)
        
    }
    
    // MARK: - 懒加载
    private lazy var refreshView:ZZ_RefreshView = ZZ_RefreshView.refreshView()
    
}
/// 刷新页面
class ZZ_RefreshView: UIView {
    /// 菊花
    @IBOutlet weak var loadIcon: UIImageView!
    /// 旋转视图所在视图
    @IBOutlet weak var tipView: UIView!
    /// 旋转视图
    @IBOutlet weak var pulldownView: UIImageView!
    /// 旋转视图标记
    var  rotateFlag = false {
        didSet {
            rotateAnimate()
        }
    }
    
    class func refreshView() -> ZZ_RefreshView {
        return NSBundle.mainBundle().loadNibNamed("ZZ_RefreshView", owner: nil, options: nil).last! as! ZZ_RefreshView
    }
    ///  箭头
    private func rotateAnimate(){
        UIView .animateWithDuration(0.3) {
            var angle = CGFloat(M_PI)
            angle += self.rotateFlag ? -0.01 : 0.01
            self.pulldownView.transform = CGAffineTransformRotate(self.pulldownView.transform, angle)
        }
    }
    ///  加载动画
    private func loadingAnimate(){
         /// loadIcon.layer.animationForKey(key) 通过key 取到动画
        if  loadIcon.layer.animationForKey(LoadingAnimationKey) != nil {
            return
        }
        
        tipView.hidden = true
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 1.2
        anim.repeatCount = MAXFLOAT
        
        loadIcon.layer.addAnimation(anim, forKey: LoadingAnimationKey)
        
    }
    ///  停止
    private func stopAnimation(){
        tipView.hidden = false
        loadIcon.layer.removeAllAnimations()
    }
    
    
}