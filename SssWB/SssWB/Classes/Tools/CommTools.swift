//
//  CommTools.swift
//  SssWB
//
//  Created by 闫波 on 16/5/21.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import Foundation
// MARK: - 通知处理
/// 更换根试图的通知
let KSwitchRootViewControllerNoti = "KSwitchRootViewControllerNoti"



// MARK: - 日志输出
/// 输出日志
///
/// - parameter message:  日志消息
/// - parameter logError: 错误标记，默认是 false，如果是 true，发布时仍然会输出
/// - parameter file:     文件名
/// - parameter method:   方法名
/// - parameter line:     代码行数
func printLog<T>(message: T,
              logError: Bool = false,
              file: String = #file,
              method: String = #function,
              line: Int = #line)
{
    if logError {
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    } else {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
}
