//
//  Emoticon.swift
//  emoticonkeyboard
//
//  Created by 闫波 on 16/6/4.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

/// 表情数据
class Emoticon: NSObject {
    /// 表情文字
    var chs : String?
    ///  表情图片
    var png : String?
    
    var imagePath : String {
        return png != nil ? NSBundle.mainBundle().bundlePath + "/Emoticons.bundle/" + png! : ""
    }
    
    ///  表情编码
    var code : String? {
        didSet{
            let scaner = NSScanner(string: code!)
            var value : UInt32 = 0;
            
            scaner.scanHexInt(&value)
            emoji = String(Character(UnicodeScalar(value)))
        }
    }
    /// 表情字符串
    var emoji : String?
    /// 删除
    var isRemove = false
    /// 空判断
    var isEmpty = false
    
    init(isEmpty:Bool) {
        super.init()
        self.isEmpty = isEmpty
    }
    
    
    init(isRemove:Bool) {
        super.init()
        
        self.isRemove = isRemove
    }
    
    init(dict:[String:String]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String{
        let keys = ["chs","png","code","isEmpty","isRemove"];
        
        return dictionaryWithValuesForKeys(keys).description
    }
}
