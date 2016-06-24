//
//  ORcodeViewController.swift
//  SssWB
//
//  Created by 闫波 on 16/6/22.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class ORcodeViewController: UIViewController{
    /// 动画视图的高度
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    /// 动画视图的宽度
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    /// 动画视图上边约束
    @IBOutlet weak var anmiationLayout: NSLayoutConstraint!
    /// tabbar
    @IBOutlet weak var tabbar: UITabBar!
    // MARK: - 视图生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbar.selectedItem = tabbar.items![0]
    }
    
    @IBOutlet weak var sacImageView: UIImageView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        barAnimation()
    }
    ///  冲击波动画
    private func barAnimation(){
        self.anmiationLayout.constant = -self.viewHeight.constant
         view.layoutIfNeeded()
        
        UIView.animateWithDuration(2.0) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.anmiationLayout.constant = self.viewHeight.constant
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func close(){
        dismissViewControllerAnimated(true, completion: nil)
    }
}


extension ORcodeViewController :UITabBarDelegate{
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        viewHeight.constant = item.tag == 1 ? viewWidth.constant * 0.5 :viewWidth.constant
        sacImageView.layer.removeAllAnimations()
        barAnimation()
    }
}