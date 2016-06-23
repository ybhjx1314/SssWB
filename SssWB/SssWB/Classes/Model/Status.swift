//
//  StatusM.swift
//  SssWB
//
//  Created by 闫波 on 16/5/24.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class Status: BaseModel {
    
    var created_at :String?//	string	微博创建时间
    var  id :Int64 = 0 //	int64	微博ID
    var text :String? //	string	微博信息内容
     //	string	微博来源
    var  source: String?{
        didSet{
            source = source?.herf()?.text
        }
    }
    
    //    pic_ids	object	微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。
    /// 用户
    var user:User?
    /// 字典数组
    var pic_urls :[[String:String]]?
    
    /// 被转发的原创微博对象
    var retweeted_status: Status?
    
    
    
    init(dict :[String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        if key == "user" {
            self.user = User(dict: value as![String:AnyObject])
            return
        }
        
        if key == "retweeted_status" {
            retweeted_status = Status(dict: value as! [String:AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override var description: String {
        let keys = ["created_at","id","text","source","user","pic_urls","retweeted_status"];
        
        return dictionaryWithValuesForKeys(keys).description
    }
}
