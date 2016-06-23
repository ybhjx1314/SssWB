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
    
    /// 格式  今天 1分钟之内(刚刚) 1小时之内(X分钟之前) 当天(X小时之前) 昨天(昨天 HH:mm) 一年内(MM-dd HH: mm) 更早(yyyy-MM-dd HH:mm)
    var dateDesMsg:String {
    
        /// 获取日历
        let calendar = NSCalendar.currentCalendar()
        
        if calendar.isDateInToday(self) {
            
            let min = Int( NSDate().timeIntervalSinceDate(self))
            
            if min < 60 {
                return "刚刚"
            }
            
            if min < 3600 {
                return "\(min / 60) 分钟前"
            }
            
            
            
            return "\(min / 3600) 小时前"
        }
        
        var fmt = " HH:mm"
        
        if calendar.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        } else {
            fmt = "MM-dd" + fmt
            
            let coms = calendar.components(.Year, fromDate: self, toDate: NSDate(), options: [])
            
            if coms.year > 0 {
                fmt = "yyyy-" + fmt
            }
        }
        
        let df = NSDateFormatter()
        df.locale = NSLocale(localeIdentifier: "en")
        df.dateFormat = fmt
        
        
        
        return df.stringFromDate(self)
    }
    
}