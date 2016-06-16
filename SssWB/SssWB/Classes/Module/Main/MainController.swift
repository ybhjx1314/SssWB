//
//  MainController.swift
//  SssWB
//
//  Created by yanbo on 16/5/12.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class MainController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewControllers()
        //调用懒加载

        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ///  视图资源只有在需要看到的时候才会添加
//        print(tabBar.subviews);
        
        setupComposedBtn();
    }
    
    
    ///  添加撰写按钮并设置位置
    @objc private func setupComposedBtn(){
        let count = childViewControllers.count
        
        let width = tabBar.bounds.width / CGFloat(count)
        
        let rect = CGRect(x: 0, y: 0, width: width, height: tabBar.bounds.height)
        
        
        composedBtn.frame = CGRectOffset(rect, 2 * width, 0);
    }
    ///  加号按钮点击事件
    @objc private func clickComposedButton(){
        let vc : UIViewController
        if UserAccountViewModel.sharedUserAccount.userLogon {
            vc = ComposeViewController()
        } else {
            vc = OAuthViewController()
        }
        
        let nav = UINavigationController(rootViewController: vc)
        
        presentViewController(nav, animated: true, completion: nil)
    }
    
    private func addChildViewControllers() {
        
        addChildViewController(HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(MessagesTableViewController(), title: "消息", imageName: "tabbar_message_center")
        ///  添加空白控制器 加号按钮的实现
        addChildViewController(UIViewController())
        addChildViewController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(ProfileTableViewController(), title: "我", imageName: "tabbar_profile")
        
    }
    ///  自定义添加控制器
    private func addChildViewController(vc:UIViewController , title:String, imageName:String) {
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        let nav = UINavigationController(rootViewController: vc)
        addChildViewController(nav)
        
    }
    
    // MARK: - 懒加载控件
    private lazy var composedBtn: UIButton = {
        let btn = UIButton()
        // 设置图像
        btn.setImage(UIImage(named:"tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: #selector(clickComposedButton), forControlEvents: UIControlEvents.TouchUpInside)
        self.tabBar.addSubview(btn)
        
        return btn
    }()
}
