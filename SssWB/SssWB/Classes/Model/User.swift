//
//  User.swift
//  SssWB
//
//  Created by 闫波 on 16/5/25.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class User: BaseModel {
    /// 用户id
    var id : Int = 0
    /// 用户姓名
    var name :String?
    /// 头像
    var profile_image_url : String?
     /// 认证类型
    var verified: Int = 0
     /// 会员等级
    var  mbrank : Int = 0
    
    // MARK: - 构造函数
    
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override var description: String{
        let key = ["id","name","profile_image_url","verified","mbrank"]
        
        return dictionaryWithValuesForKeys(key).description
    }
}
