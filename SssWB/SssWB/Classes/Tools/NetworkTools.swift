//
//  NetworkTools.swift
//  SssWB
//
//  Created by yanbo on 16/5/20.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
import AFNetworking
import ReactiveCocoa


enum RequestMethod :String {
    case GET = "GET"
    case POST = "POST"
}

/// 网络工具
class NetworkTools: AFHTTPSessionManager {

    // MARK: - APP 信息
    private let client_id = "3236505966"
    
    private let appScre = "ce51d512b50aaea263488d38b6fa216d"
    
    let redirectUri = "http://www.baidu.com"
    
    
    ///  单例
    static let shareTools : NetworkTools = {
        /// 设置baseURL
        let instance = NetworkTools(baseURL: nil);
        ///  添加反序列化类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return instance
    }()
    ///  获取用户token
    ///
    ///  - parameter code: 授权码
    func loadAccountToken(code:String) -> RACSignal{
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parms = ["client_id":client_id,
                     "client_secret":appScre,
                     "grant_type":"authorization_code",
                     "code":code,
                     "redirect_uri":redirectUri,
                     ]
        return self.request(.POST, URLString: urlString, parameters: parms ,withToken: false)
    }
    
    func loadUserInfo(uid:String) -> RACSignal {
        let urlString = "https://api.weibo.com/2/users/show.json"
        let params = ["uid":uid]
        
        return request(.GET, URLString: urlString, parameters: params);
    }
    
    // MARK: - 微博接口
    ///  首页微博数据
    func loadStatus(since_id since_id: Int64 ,max_id : Int64) -> RACSignal{
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        var params = [String:AnyObject]()
        
        if since_id > 0 {
            params["since_id"] = NSNumber(longLong: since_id)
        } else if (max_id != 0) {
            params["max_id"] = NSNumber(longLong: max_id - 1)
        }
        
        return request(.GET, URLString: urlString, parameters: params)
    }
    
    

    
    // MARK: - OAuth
    /// OAuth 授权 URL
    /// - see [http://open.weibo.com/wiki/Oauth2/authorize](http://open.weibo.com/wiki/Oauth2/authorize)
    var oauthStr :NSURL{
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirectUri)"
        
        return NSURL(string: urlString)!
    }
    // MARK: - 网络请求
    ///  添加请方法
   private func request(methoud:RequestMethod , URLString : String , var parameters:[String:AnyObject]? , withToken :Bool = true) -> RACSignal{
        // guard 与 if let 相反
    
    
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            if withToken {
                guard let token = UserAccountViewModel.sharedUserAccount.accountToken else {
                    // token == nil
                    
                    
                    subscriber.sendError(NSError(domain: "com.meicai.com", code: -1001, userInfo: ["errorMessage":"Token 为空"]));
                    
                    return nil
                }
                if parameters == nil {
                    parameters = [String:AnyObject]()
                }
                
                parameters!["access_token"] = token
                
            }
            
            /// 请求成功闭包
            let successBack = ({ (task: NSURLSessionDataTask, result : AnyObject?) -> Void in
                ///  将结果发送给订阅者
                subscriber.sendNext(result);
                // 请求完成
                subscriber.sendCompleted()
            })
            
            let failureBack = ({ (task : NSURLSessionDataTask?, error : NSError) -> Void in
                print(error)
                // 将错误发送给订阅者
                subscriber.sendError(error)
            })
            printLog(parameters)
            if methoud == .GET {
                self.GET(URLString, parameters: parameters, progress: nil, success: successBack, failure: failureBack)
            } else {
                self.POST(URLString, parameters: parameters, progress: nil, success: successBack, failure: failureBack)
                
            }
            return nil
            
        })
        
        
        
    }
    
}
