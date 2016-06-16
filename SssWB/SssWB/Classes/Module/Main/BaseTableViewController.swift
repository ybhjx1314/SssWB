//
//  BaseTableViewController.swift
//  SssWB
//
//  Created by yanbo on 16/5/17.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController/*,VistorLoginViewDelegate*/ {
    /// 用户是否登陆
    var userLogon = UserAccountViewModel.sharedUserAccount.userLogon
//    var userLogon = false
    ///  设置访客页面
    var visterView : VistorLoginView?
    
    override func loadView() {
        userLogon ? super.loadView() : setupVistorView()
    }
    ///  设置访客视图
    private func setupVistorView(){
        visterView = VistorLoginView()
//        visterView?.delegate = self
        view = visterView
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseTableViewController.registerButtonClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(longinButtonClick))
        visterView?.registerButton.addTarget(self, action: #selector(registerButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        visterView?.loginButton.addTarget(self, action: #selector(longinButtonClick) , forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func longinButtonClick() {
        
        let vc =  UINavigationController(rootViewController: OAuthViewController())
        presentViewController(vc, animated: true, completion: nil)
        printLog("denglu ")
    }
    
    func registerButtonClick() {
        
        print("zhuce ")
    }
    
    
    
}
