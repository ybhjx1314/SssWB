//
//  WelcomeViewController.swift
//  SssWB
//
//  Created by yanbo on 16/5/24.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    
    private var iconViewButtom : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        iconImageView.sd_setImageWithURL(UserAccountViewModel.sharedUserAccount.avatarUrl)
    }
    ///  设置界面
    private func setupUI(){
         /// 1 添加控件
        view.addSubview(backImageView)
        view.addSubview(iconImageView)
        view.addSubview(testLabel)
         /// 2 设置位置
        backImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[v]-0-|", options: [], metrics: nil, views: ["v":backImageView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[v]-0-|", options: [], metrics: nil, views:["v":backImageView]))
        
        let cons = iconImageView.zz_AlignInner(type: zz_LocationType.CenterButtom, referView: view, size: CGSizeMake(90, 90), offset: CGPoint(x: 0, y: -200))
        self.iconViewButtom = iconImageView.zz_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        testLabel.zz_AlignVertical(type: zz_LocationType.CenterButtom, referView: iconImageView, size: nil, offset: CGPoint(x: 0, y: 20))
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let h = -(UIScreen.mainScreen().bounds.height + iconViewButtom!.constant)
        
        iconViewButtom?.constant = h
        testLabel.alpha = 0
        UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 8, options:[], animations: {
            self.view.layoutIfNeeded()
            }) { (_) in
                
                UIView.animateWithDuration(0.8, animations: { 
                    self.testLabel.alpha = 1
                    }, completion: { (_) in

                        NSNotificationCenter.defaultCenter() .postNotificationName(KSwitchRootViewControllerNoti, object: nil)
                })
                
        }
    }
    
    
    // MARK: - 懒加载控件
    // 背景图
    private lazy var backImageView = UIImageView(image: UIImage(named: "ad_background"))
    // 头像
    private lazy var iconImageView :UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.cornerRadius = 45
        iv.layer.masksToBounds = true
        return iv
    }()
    // 文字
    private lazy var testLabel = UILabel(title: "欢迎屌丝归来", color: UIColor.darkGrayColor(), fontSize: 18)
}
