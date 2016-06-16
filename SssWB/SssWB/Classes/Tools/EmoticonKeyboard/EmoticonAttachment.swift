//
//  EmoticonAttachment.swift
//  emoticonkeyboard
//
//  Created by yanbo on 16/6/6.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class EmoticonAttachment: NSTextAttachment {

    var chs:String
    
    
    init(chs:String){
        self.chs = chs
        super.init(data: nil, ofType: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func emoticonAttributeText(emoticon:Emoticon , font:UIFont) ->NSAttributedString {
        let attachment = EmoticonAttachment(chs: emoticon.chs!)
        
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath)
        /// 图片高度
        let height = font.lineHeight;
        
        attachment.bounds = CGRectMake(0, -4, height, height)
        
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        
        imageText.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0,length: 1))
        
        return imageText
        
    }
    
    
}
