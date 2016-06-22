//
//  NSDate+Extension.swift
//  SssWB
//
//  Created by 闫波 on 16/6/21.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import Foundation

extension NSDate {
    ///   返回新浪日期
    class func sinaDate(str:String) -> NSDate? {
        let df = NSDateFormatter()
        
        df.locale = NSLocale(localeIdentifier: "en")
        
        df.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        return df.dateFromString(str)
        
    }
    
    var dateDesMsg:String {
    
        /// 获取日历
        let calendar = NSCalendar.currentCalendar()
        
        if calendar.isDateInToday(self) {
            return "今天"
        }
        
        if calendar.isDateInYesterday(self) {
            return "昨天"
        }
        
        
        return "其他"
    }
    
}