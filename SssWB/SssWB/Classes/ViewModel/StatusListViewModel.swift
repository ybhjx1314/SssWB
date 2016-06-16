//
//  StatusListViewModel.swift
//  SssWB
//
//  Created by 闫波 on 16/5/24.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SDWebImage

/// 微博列表视图模型  //TODO: 分离网络请求
class StatusListViewModel: NSObject {
    /// 微博数据数组
    lazy var statuses = [StatusViewModel]()
    
    ///  加载微博数据
    func loadStatuses(ispullUpRefresh ispullUpRefresh:Bool) -> RACSignal{
        
        /// 微博下拉参数
        var since_id  = statuses.first?.status.id ?? 0
        
        /// 微博上拉参数
        var max_id :Int64 = 0
        ///  如果是上拉刷新 上拉参数为0
        if ispullUpRefresh {
            since_id = 0
            max_id  = statuses.last?.status.id ?? 0
        }
        printLog("开始 \(since_id) 结束\(max_id)")
        return RACSignal.createSignal({ [weak self] (subscriber) -> RACDisposable! in
            
            NetworkTools.shareTools.loadStatus(since_id: since_id,max_id: max_id).subscribeNext({ (result) in
                /// 类型转换 
                let dict = result as! [String: AnyObject]
                guard let array = dict["statuses"] as? [[String:AnyObject]] else {
                     
                    printLog("没有数据")
                    
                    subscriber.sendError(NSError(domain: "com.yanbo.com", code: -1101, userInfo: ["message" : "你麻痹,服务器有问题,给老子修复数据去"]))
                    
                    return
                }
                
                ///  建立临时数组 存当前网络请求的结果
                var arrayM = [StatusViewModel]()
                
                for dict in array {
                    arrayM.append(StatusViewModel(status:  Status(dict: dict)))
                }
                
                printLog("刷新到\(arrayM.count)条微博 -------")
                
                ///  尾随闭包
                self?.cacheImage(arrayM)
                {
                    if max_id > 0 {
                        ///  max 大于0 表示是加载数据 需要拼接到后面
                        self?.statuses =  self!.statuses + arrayM
                    } else {
                        /// 反之 需要加载前面
                        self?.statuses = arrayM + self!.statuses
                    }
                    
                    if since_id > 0 {
                        subscriber.sendNext(arrayM.count)
                    }
                    
                    /// 通知 数据加载完成
                    subscriber.sendCompleted()
                }
                printLog(self?.statuses)
                }, error: { (error) in
                    printLog(error)
                    subscriber.sendError(error)
            }){}
            return nil
        })
        
        
    }
    
    ///  缓存网络图片
    ///
    ///  - parameter array:    模型数组
    ///  - parameter finished: 完成闭包
    private func cacheImage(array:[StatusViewModel],finished:()->()) {
        /// 1调度
        let group = dispatch_group_create()
        var dataLength = 0
        
        for viewModel in array {
            
            let count = viewModel.thumbnailURLs?.count ?? 0
            
            if count != 1 {
                continue
            }
            printLog(viewModel.thumbnailURLs)
            /// 2入组
            dispatch_group_enter(group)
            ///  缓存一张图片
            
            SDWebImageManager.sharedManager().downloadImageWithURL(viewModel.thumbnailURLs![0], options: [], progress: nil, completed: { (image, error, _, _, _) in
                /// 这里图片下载完成 这里不一定有图片
                
                if image != nil {
                    
                    let data = UIImagePNGRepresentation(image)
                    
                    dataLength += data?.length ?? 0
                    
                }
                
                ///3  出
                dispatch_group_leave(group)
            })
            
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            printLog("图片缓存完成 \(dataLength / 1024) K")
            finished()
        }
    }
    
}