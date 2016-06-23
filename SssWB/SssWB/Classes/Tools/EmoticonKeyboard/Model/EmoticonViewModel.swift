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
    
    ///  根据给定的表情 生成对应的属性字符串
    func emoticonText(str: String , font:UIFont) -> NSAttributedString {
        /// 正则表达式
        let pattern = "\\[.*?\\]"
        
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        /// 根据正则获得每一个符合规则的对象在字符串中的位置
        let results = regex.matchesInString(str, options: [], range: NSRange(location: 0, length: (str as NSString).length))
        /// 确定循环次数
        var count = results.count
        /// 创建可变属性字符串
        let retStr = NSMutableAttributedString(string: str)
        
        while count > 0 {
            count = count - 1
            
            let range = results[count].rangeAtIndex(0)
            
            let chs = (str as NSString).substringWithRange(range)
            
            if let emoticon = emoticon(chs) {
                let imageText = EmoticonAttachment.emoticonAttributeText(emoticon, font: font)
                
                retStr.replaceCharactersInRange(range, withAttributedString: imageText)
            }
            
        }
        
        return retStr
    }
    
    
    ///  根据字符串查找表情
    ///
    ///  - parameter str: 表情字符串
    ///
    ///  - returns: 表情对象
    func emoticon(str:String) -> Emoticon? {
        var emotiocn : Emoticon?
        
        for p in packages {
            /// 从数组中找对应属性的元素
//            emotiocn = p.emoticons.filter({ (em) -> Bool in
//                return em.chs == str
//            }).last
            /// 简单写法
            emotiocn = p.emoticons.filter() {$0.chs == str}.last
            
            if emotiocn != nil {
                break
            }
        }
        return emotiocn
    }
    
    /// 加载表情包
    init () {
        loadPackages()
    }
    
    /// 添加最近的表情
    ///
    /// - parameter indexPath: indexPath
    func favorite(indexPath: NSIndexPath) {
        // 0. 如果是第0个分组，不参与排序
        if indexPath.section == 0 {
            return
        }
        
        // 1. 获取表情符号
        let em = emoticon(indexPath)
        em.times += 1
        
        // 2. 将表情符号添加到第0组的首位
        // 判断是否已经存在表情
        if !packages[0].emoticons.contains(em) {
            packages[0].emoticons.insert(em, atIndex: 0)
        }
        
        // 3. 对数组进行排序 直接排序当前数组 sortInPlace
        // Swift中，对尾随闭包，同时有返回值的又一个简单的写法
        //        packages[0].emoticons.sortInPlace { (obj1, obj2) -> Bool in
        //            return obj1.times > obj2.times
        //        }
        // $0 对应第一个参数，$1对应第二个参数，依次类推，return 可以省略
        packages[0].emoticons.sortInPlace { $0.times > $1.times }
        
        // 4. 删除多余的表情 － 倒数第二个
        if packages[0].emoticons.count > 21 {
            packages[0].emoticons.removeAtIndex(19)
        }
        
        // 数组的调试技巧
        printLog(packages[0].emoticons as NSArray)
        printLog(packages[0].emoticons.count)
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
