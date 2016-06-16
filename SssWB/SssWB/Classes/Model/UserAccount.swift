//
//  UserAccount.swift
//  SssWB
//
//  Created by 闫波 on 16/5/21.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class UserAccount: BaseModel,NSCoding{
    
    
    var expires_in  : NSTimeInterval = 0 {
        didSet {
            expireDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    

    var access_token : String?
    
    var uid :String?
    /// 过期时间
    var expireDate :NSDate?
    // 大图
    var avatar_large : String?
    // 姓名
    var name :String?
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    
    
    override var description: String {
        let keys = ["access_token","expires_in","uid","expireDate","name","avatar_large"];
        return dictionaryWithValuesForKeys(keys).description
     }
    
    static let accountPath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("account.plist")
    ///  存用户信息
    func saveUserAccount(){
        printLog(UserAccount.accountPath)
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.accountPath);
    }
    ///  取用户信息
    ///
    ///  - returns: 用户信息
    class func loadUserAccount() -> UserAccount?{
        let accont = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.accountPath) as? UserAccount;
        if let date = accont?.expireDate{
            // 比较日期 date > NSDate() 结果是降序
            if date.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                
                return accont
            }
            
        }
        return nil;
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expireDate , forKey: "expireDate")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(uid, forKey: "uid")
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        uid  = aDecoder.decodeObjectForKey("uid") as? String
        expireDate = aDecoder.decodeObjectForKey("expireDate") as? NSDate
        
        
        
    }
    
}
