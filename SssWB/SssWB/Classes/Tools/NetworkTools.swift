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
    
    // MARK: - 私有方法，封装 AFN 的网络请求方法
    /// 在指定参数字典中追加 accessToken
    ///
    /// - parameter parameters: parameters 地址
    ///
    /// - returns: 是否成功，如果token失效，返回 false
    private func appendToken(inout parameters: [String: AnyObject]?) -> Bool {
        
        // 判断单例中的 token 是否有效
        guard let token = UserAccountViewModel.sharedUserAccount.accountToken else {
            return false
        }
        
        // 判断是否传递了参数字典
        if parameters == nil {
            parameters = [String: AnyObject]()
        }
        
        // 后续的 token 都是有值的
        parameters!["access_token"] = token
        
        return true
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
    
    // MARK: - 发布微博
    /// 发布微博
    ///
    /// - parameter status: 微博文本，不能超过 140 个字，需要百分号转义(AFN会做)
    /// - parameter image:  如果有，就上传图片
    ///
    /// - returns: RAC Signal
    /// - see: [http://open.weibo.com/wiki/2/statuses/update](http://open.weibo.com/wiki/2/statuses/update)
    /// - see: [http://open.weibo.com/wiki/2/statuses/upload](http://open.weibo.com/wiki/2/statuses/upload)
    func sendStatus(status: String, image: UIImage?) -> RACSignal {
        
        let params = ["status": status]
        
        // 如果没有图片，就是文本微博
        if image == nil {
            // 文本微博
            return request(.POST, URLString: "https://api.weibo.com/2/statuses/update.json", parameters: params)
        } else {
            // 图片微博
            return upload("https://upload.api.weibo.com/2/statuses/upload.json", parameters: params, image: image!)
        }
    }
    

    
    // MARK: - OAuth
    /// OAuth 授权 URL
    /// - see [http://open.weibo.com/wiki/Oauth2/authorize](http://open.weibo.com/wiki/Oauth2/authorize)
    var oauthStr :NSURL{
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirectUri)"
        
        return NSURL(string: urlString)!
    }
    // MARK: - 网络请求
    
    // 上传文件
    /// 上传文件
    ///
    /// - parameter URLString:  URLString
    /// - parameter parameters: parameters
    /// - parameter image:      image
    ///
    /// - returns: RAC Signal
    private func upload(URLString: String, var parameters: [String: AnyObject]?, image: UIImage) -> RACSignal {
        
        // 闭包返回值是对信号销毁时需要做的内存销毁工作，同样是一个 block，AFN 的可以直接 nil
        return RACSignal.createSignal() { (subscriber) -> RACDisposable! in
            
            // 0. 判断是否需要 token － 将代码放在最合适的地方
            if !self.appendToken(&parameters) {
                subscriber.sendError(NSError(domain: "com.itheima.error", code: -1001, userInfo: ["errorMessage": "Token 为空"]))
                return nil
            }
            
            // 1. 调用 AFN 的上传文件方法
            self.POST(URLString, parameters: parameters, constructingBodyWithBlock: { (formData) -> Void in
                
                // 将图像转换成二进制数据
                let data = UIImagePNGRepresentation(image)!
                
                // formData 是遵守协议的对象，AFN内部提供的，使用的时候，只需要按照协议方法传递参数即可！
                /**
                 1. 要上传图片的二进制数据
                 2. 服务器的字段名，开发的时候，咨询后台
                 3. 保存在服务器的文件名，很多后台允许随便写
                 4. mimeType -> 客户端告诉服务器上传文件的类型，格式
                 大类/小类
                 image/jpg
                 image/gif
                 image/png
                 如果，不想告诉服务器具体的类型，可以使用 application/octet-stream
                 
                 */
                formData.appendPartWithFileData(data, name: "pic", fileName: "ohoh", mimeType: "application/octet-stream")
                
                }, success: { (_, result) -> Void in
                    
                    subscriber.sendNext(result)
                    subscriber.sendCompleted()
                    
                }, failure: { (_, error) -> Void in
                    printLog(error, logError: true)
                    
                    subscriber.sendError(error)
            })
            
            return nil
        }
    }
    
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
