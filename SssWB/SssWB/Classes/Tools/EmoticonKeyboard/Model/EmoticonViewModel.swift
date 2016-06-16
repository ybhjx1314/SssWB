//
//  EmoticonViewModel.swift
//  emoticonkeyboard
//
//  Created by 闫波 on 16/6/4.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit


class EmoticonViewModel {
    
    static let sharedViewModel = EmoticonViewModel()
    
    lazy var packages = [EmoticonPackage]()
    /// 加载表情包
    init () {
        loadPackages()
    }
    
    func loadPackages(){
        /// 取到包所在的位置
        
        packages.append(EmoticonPackage(dict: ["group_name_cn":"最近AB"]))
        
        let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        /// 确认路径正确
//        print(path)
        /// 取得字典
        let dict = NSDictionary(contentsOfFile: path!)
        
        let array = dict!["packages"] as! [[String:AnyObject]]
        
        for infoDict in array {
            //1. 取得字典中id对应的info.plist
            let id = infoDict["id"] as! String
            
            let emPath = NSBundle.mainBundle().pathForResource("info.plist", ofType: nil, inDirectory: "Emoticons.bundle/" + id)
            
            
            let packDict = NSDictionary(contentsOfFile: emPath!) as! [String:AnyObject]
            
            
            
            packages.append(EmoticonPackage(dict: packDict))
            
        }
        
    }
    
    func emoticon(indexpath:NSIndexPath) -> Emoticon {
        return packages[indexpath.section].emoticons[indexpath.item]
    }
    
}
