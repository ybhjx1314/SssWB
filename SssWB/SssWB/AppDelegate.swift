//
//  AppDelegate.swift
//  SssWB
//
//  Created by yanbo on 16/5/12.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
import AFNetworking


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(switchRootVC), name: KSwitchRootViewControllerNoti, object: nil)
        
        
        printLog(UserAccountViewModel.sharedUserAccount.userAccount);
        
        // 设置网络
        setupNetworking()
        // 设置全局外观
        setupAppearance()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = defaultRVC()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: KSwitchRootViewControllerNoti, object: nil)
    }
    
    
    func switchRootVC (noti:NSNotification){
        printLog(noti)
        window?.rootViewController = (noti.object == nil) ? MainController() : WelcomeViewController()
    }
    
    
    ///  设置rootvc
    ///
    ///  - returns: rvc
    private func defaultRVC() -> UIViewController{
        // 1 判断用户是否登陆
        if UserAccountViewModel.sharedUserAccount.userLogon{
            // 判断是否是新版本
            return isNewVersion() ? NewFeatureVC() : WelcomeViewController()
        }
        
        return MainController()
    }
    
    
    private func isNewVersion() -> Bool{
        // 1 bundle 中有什么 找到app version
        let bundleVersion = Double( NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String)!
        // 2 从本地取出version
        let versionkey = "com.meicai.com"
        let saxboxVersion = NSUserDefaults.standardUserDefaults().doubleForKey(versionkey)
        printLog(saxboxVersion)
        
        // 3 保存版本
        NSUserDefaults.standardUserDefaults().setDouble(bundleVersion, forKey: versionkey)
        
        return bundleVersion > saxboxVersion
        
    }
    
    
    private func setupNetworking(){
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true;
        ///  设置缓存大小
        /// Disk path: <nobr>(user home directory)/Library/Caches/(application bundle id)
        let cache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(cache)
    }
    
    ///  修改导航栏外观
    private func setupAppearance(){
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        ///  设置tabbar渲染颜色
        UITabBar.appearance().tintColor = UIColor.orangeColor();
    }

}

