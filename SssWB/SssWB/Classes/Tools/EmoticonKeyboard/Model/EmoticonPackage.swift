//
//  EmoticonPackage.swift
//  emoticonkeyboard
//
//  Created by 闫波 on 16/6/4.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

/// 表情包模型
class EmoticonPackage: NSObject {
    /// 目录名
    var id : String?
    /// 分组名
    var group_name_cn :String?
    /// 表情模型数组
    lazy var emoticons = [Emoticon]()
    
    init(dict:[String:AnyObject]) {
        super.init()
        id = dict["id"] as? String
        group_name_cn = dict["group_name_cn"] as? String
        
        
        var index = 0;
        if let array = dict["emoticons"] as? [[String:String]] {
            
            
            for var dic  in array {
                if let imagePath = dic["png"]{
                   dic["png"] = id! + "/" + imagePath
                }
                
                emoticons.append(Emoticon(dict: dic))
                index += 1
                if index == 20 {
                    emoticons.append(Emoticon(isRemove: true))
                    index = 0
                }
            }
            
        }
        
        appendEmpty()
        
    }
    
    func appendEmpty(){
        let count = emoticons.count % 21
        
        if count == 0 && emoticons.count > 0 {
            return
        }
        
        for _ in count..<20 {
            emoticons.append(Emoticon(isEmpty: true))
        }
        
        emoticons.append(Emoticon(isRemove: true))
        
    }
    
    override var description: String{
        let keys = ["id","group_name_cn","emoticons"];
        
        return dictionaryWithValuesForKeys(keys).description
    }
    
}
