//
//  OAuthViewController.swift
//  SssWB
//
//  Created by yanbo on 16/5/20.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
import SVProgressHUD


class OAuthViewController: UIViewController ,UIWebViewDelegate {

    
    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        webView.delegate = self
        title = "登陆新浪微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(close))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(tianChong))
    }
    @objc private func close(){
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func tianChong(){
        let js = "document.getElementById('userId').value = '13521693775';" +
        "document.getElementById('passwd').value = 'wlp1314hjx';"
        webView.stringByEvaluatingJavaScriptFromString(js)
        
    }
    
    override func viewDidLoad() {
        webView.loadRequest(NSURLRequest(URL:NetworkTools.shareTools.oauthStr))
    }
    // MARK: - 网页回调
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        /// 拿到加载请求的url中的字符串
        let urlString = request.URL!.absoluteString
        /// 判断字符串中前缀是不是回调地址
        if !urlString.hasPrefix(NetworkTools.shareTools.redirectUri) {
            
            return true;
        }
        
        if let query = request.URL!.query where query.hasPrefix("code="){
            let code = query.substringFromIndex("code=".endIndex)
            
            UserAccountViewModel.sharedUserAccount.loadUserAccount(code).subscribeError({ (error) in
                printLog(error)
                }, completed: {
                    
                    SVProgressHUD.dismiss()
                    self.dismissViewControllerAnimated(false, completion: {
//
                        NSNotificationCenter.defaultCenter() .postNotificationName(KSwitchRootViewControllerNoti, object: "main")
                    })
            })
        } else {
            print("取消")
        }
        
        
        return false
    }
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
}
 