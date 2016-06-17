//
//  UITextView+Emoticon.swift
//  emoticonkeyboard
//
//  Created by yanbo on 16/6/6.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit


extension UITextView {
    /// 表情属性字符
    var emoticonString : String
    {
        
        let attribute = attributedText
        
        var strM = String()
        
        attribute.enumerateAttributesInRange(NSRange(location: 0,length: attribute.length), options: []) { (dict, range, _) in
            
            if let attribute = dict["NSAttachment"] as? EmoticonAttachment {
                strM += attribute.chs
            } else {
                let str = (attribute.string as NSString).substringWithRange(range)
                
                strM += str
            }
            
        }
        return strM
    }
    
    
    ///  插入表情文字
    ///  - parameter emoticon: 表情模型
    func insterEmoticon(emoticon:Emoticon){
        
        if emoticon.isEmpty {
            return
        }
        
        ///  删除按钮
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        
        /// 表情 emjio
        if emoticon.emoji != nil {
            replaceRange(selectedTextRange!, withText: emoticon.emoji!)
            return
        }
        
        /// 插入图片 图文混怕
        // 1富文本
        let imageText = EmoticonAttachment.emoticonAttributeText(emoticon, font: font!)
        /// 从输入框中取出富文本
        let mutabelImageText = NSMutableAttributedString(attributedString: attributedText)
        // 2 插入图片文字
        mutabelImageText.replaceCharactersInRange(selectedRange, withAttributedString: imageText)
        /// 记录当前选择的位置
        let rang = selectedRange
        // 3 赋值
        attributedText = mutabelImageText
        
        // 4 还原光标位置
        selectedRange = NSRange(location: rang.location + 1, length: 0)
        
        delegate?.textViewDidChange!(self)
    }
}