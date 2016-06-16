//
//  StatusViewModel.swift
//  SssWB
//
//  Created by 闫波 on 16/5/26.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

/// 原创微博cell
let statusNormalCellID = "statusNormalCellID"
/// 转发微博的cell
let statusForwardCellID = "statusForwardCellID"

class StatusViewModel: NSObject {
    /// 模型
    var status:Status
    /// 行高
    var rowHeight:CGFloat = 0
    
    var  cellID : String {
        return status.retweeted_status != nil ? statusForwardCellID : statusNormalCellID
    }
    
    
    /// 被转发的博文
    var forwordText : String? {
        let username = status.retweeted_status?.user?.name ?? ""
        let text = status.retweeted_status?.text ?? ""
        
        return "@\(username):\(text)"
    }
    
    /// 用户头像
    var iconUrl : NSURL? {
        return NSURL(string: status.user?.profile_image_url ?? "")
    }
    /// 大V头像标志
    var vipImage :UIImage? {
        switch (status.user?.verified ?? -1){
        case 0: return UIImage(named: "avatar_vip")
        case 2,3,5: return UIImage(named: "avatar_enterprise_vip")
        case 220 : return UIImage(named: "avatar_grassroot")
        default : return nil
        }
    }
    
    var mbRankImage: UIImage? {
        if status.user?.mbrank > 0 && status.user?.mbrank < 7 {
            return UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
        }
        return nil
    }
    
    
    var thumbnailURLs : [NSURL]?
    
    var bmiddleURLs: [NSURL]? {
        // 1. 判断 thumbnailURLs 是否为 nil
        guard let urls = thumbnailURLs else {
            return nil
        }
        
        // 2. 顺序替换每一个 url 字符串中的单词
        var array = [NSURL]()
        
        for url in urls {
            let urlString = url.absoluteString.stringByReplacingOccurrencesOfString("/thumbnail/", withString: "/bmiddle/")
            
            array.append(NSURL(string: urlString)!)
        }
        return array
    }
    
    // MARK: - 构造函数
    
    init(status:Status){
        self.status = status
        
        if let urls = status.retweeted_status?.pic_urls ?? status.pic_urls {
            
            thumbnailURLs = [NSURL]()
            
            for dict in urls {
                thumbnailURLs?.append(NSURL(string:dict["thumbnail_pic"]!)!)
            }
        }
        
        
         super.init()
    }
    
    override var description: String{
        return status.description + "缩率图 \(thumbnailURLs)"
    }
    
}
