//
//  PhotoBrowserAnimator.swift
//  SssWB
//
//  Created by yanbo on 16/6/16.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

/// 转场动画提供者
class PhotoBrowserAnimator: NSObject, UIViewControllerTransitioningDelegate{
    /// 是否是开始
    var isPresent = false
    
    /// 动画开始的位置&结束的位置
    var fromRect = CGRectZero
    var toRect = CGRectZero
    /// 图片地址
    var url : NSURL?
    
    
    /// 图像视图 -> 用于动画
    lazy var imageView : UIImageView = {
        let iv = UIImageView()
        
        iv.contentMode = UIViewContentMode.ScaleAspectFit
        iv.clipsToBounds = true
        
        return iv
        
    }()
    
    func prepareAnimator(fromRect:CGRect,toRect:CGRect,url:NSURL){
        self.fromRect = fromRect
        self.toRect = toRect
        self.url = url
    }
    
    /// 开始动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
        
        return self
    }
    
    /// 结束动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = false
        
        return self
    }
    
    
}

// MARK: - UIViewControllerAnimatedTransitioning
// 转场动画协议
extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    /// 转场动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    ///  转场动画效果
    ///
    ///  - parameter transitionContext: 上下文 提供动画实现的所有细节
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        /// 来源控制器
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
     
        printLog(fromVC)
        printLog(toVC)
        
        isPresent == true ? presentAnimation(transitionContext) : dismissAnimation(transitionContext)
    }
    ///  展现
    ///
    ///  - parameter transitionContext: transitionContext上下文
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning){
        // 获得容器试图
        // 展现动画试图
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        toView.alpha = 0
        let contView = transitionContext.containerView()
        contView?.addSubview(toView)
        ///  开始present动画
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            
            toView.alpha = 1;
            
        }) { (_) in
            ///  关闭动画
            transitionContext.completeTransition(true)
        }
        
    }
    ///  消失
    ///
    ///  - parameter transitionContext: transitionContext上下文
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning){
        ///  拿到当前展现的试图-> fromView
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { 
            fromView.alpha = 0
            }) { (_) in
                
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
        
    }
    
}