//
//  String+Extension.swift
//  SssWB
//
//  Created by yanbo on 16/6/22.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import Foundation

extension String {
    
    func herf() -> (link:String,text:String)? {
        
        let pattren = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        let regex = try! NSRegularExpression(pattern: pattren, options: [NSRegularExpressionOptions.DotMatchesLineSeparators])
        
        guard let result = regex.firstMatchInString(self, options: [], range: NSRange(location: 0, length: self.characters.count)) else {
            return nil
        }
        
        let link = (self as NSString).substringWithRange(result.rangeAtIndex(1))
        let text = (self as NSString).substringWithRange(result.rangeAtIndex(2))
        
        return (link,text)
    }

}