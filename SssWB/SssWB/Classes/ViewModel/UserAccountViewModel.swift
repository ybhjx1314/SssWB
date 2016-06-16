//
//  UserAccountViewModel.swift
//  SssWB
//
//  Created by yanbo on 16/5/23.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
import ReactiveCocoa


class UserAccountViewModel: NSObject {
    /// 单利
    static let sharedUserAccount = UserAccountViewModel()
    
    override init() {
        userAccount = UserAccount.loadUserAccount()
    }
    
    /// 用户信息
    var userAccount : UserAccount?
    
    /// token
    var accountToken : String? {
        return userAccount?.access_token
        
    }
    
    var avatarUrl : NSURL? {
        return NSURL(string: userAccount?.avatar_large ?? "")
    }
    
    var userLogon : Bool {
        return userAccount?.access_token != nil
    }
    
    
    func loadUserAccount (code:String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            ///  donext -> 可以给当前信号增加附加操作 将当前信号的结果作为下一个信号的开始
            NetworkTools.shareTools.loadAccountToken(code).doNext({ (result) in
                printLog(result);
                let account = UserAccount(dict: result as! [String:AnyObject])
                self.userAccount = account
                printLog(account)
                NetworkTools.shareTools.loadUserInfo(account.uid!).subscribeNext({ (result) in
                    let dict = result as! [String:AnyObject]
                    account.name = dict["name"] as? String
                    account.avatar_large = dict["avatar_large"] as?String
                    printLog(account)
                    
                    account.saveUserAccount();
                    
                    subscriber.sendCompleted()
                    
                    }, error: { (error) in
                        subscriber.sendError(error);
                })
            }).subscribeError({ (error) in
                subscriber.sendError(error);
            })
            
            return nil
        })
        
        
    }
    
    
}

