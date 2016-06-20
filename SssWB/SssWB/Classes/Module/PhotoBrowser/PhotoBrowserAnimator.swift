//
//  PhotoBrowserAnimator.swift
//  SssWB
//
//  Created by yanbo on 16/6/16.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
import SDWebImage
/// 转场动画提供者
class PhotoBrowserAnimator: NSObject, UIViewControllerTransitioningDelegate{
    /// 是否是开始
    var isPresent = false
    
    /// 动画开始的位置&结束的位置
    var fromRect = CGRectZero
    var toRect = CGRectZero
    /// 图片地址
    var url : NSURL?
    
    weak var picView :StatusPictureView?
    
    /// 图像视图 -> 用于动画
    lazy var imageView : ProgressImageView = {
        let iv = ProgressImageView()
        
        iv.contentMode = UIViewContentMode.ScaleAspectFit
        iv.clipsToBounds = true
        
        return iv
        
    }()
    
    func prepareAnimator(fromRect:CGRect,toRect:CGRect,url:NSURL,picView:StatusPictureView){
        self.picView = picView
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
        
        // 1 将动画视图添加到容器视图上
        transitionContext.containerView()?.addSubview(imageView)
        self.imageView.frame  = self.fromRect
        // 2 下载图像
        imageView.sd_setImageWithURL(url, placeholderImage: nil, options: [SDWebImageOptions.RetryFailed], progress: { (current, total) in
            print("\(current) \(total) \(NSThread.currentThread())")
            dispatch_async(dispatch_get_main_queue()) {
                self.imageView.progress = CGFloat(current) / CGFloat(total)

            }
            
            }) { (image, error, _, _) in
                
                if error != nil {
                    printLog(error, logError: true)
                    transitionContext.completeTransition(false)
                    return
                }
                
                // 3 显示动画
                UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { 
                    // 动画属性
                    self.imageView.frame = self.toRect
                    }, completion: { (_) in
                        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
                        transitionContext.containerView()?.addSubview(toView)
                        
                        self.imageView .removeFromSuperview()
                        transitionContext.completeTransition(true)
                        
                })
        }
    }
    ///  消失
    ///
    ///  - parameter transitionContext: transitionContext上下文
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning){
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! as! PhotoBrowserViewController
        let imageView = fromVC.currentImageView
        
        ///  拿到当前展现的试图-> fromView
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        
        fromView.removeFromSuperview()
        /// 设置imageview的位子
        imageView.center = fromView.center
        
        /// 叠加形变
        let scale = fromVC.view.transform.a
        imageView.transform = CGAffineTransformScale(imageView.transform, scale, scale)
        imageView.alpha = scale
        
        transitionContext.containerView()?.addSubview(imageView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            imageView.frame = self.picView!.screenRect(fromVC.currentImageIndexPath)
            imageView.alpha = 1.0
            }) { (_) in
                imageView.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
        
    }
    
}