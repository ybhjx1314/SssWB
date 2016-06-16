//
//  BaseModel.swift
//  SssWB
//
//  Created by yanbo on 16/5/25.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
    
    override func setNilValueForKey(key: String) {}
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}

    override func setValue(value: AnyObject?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
}
