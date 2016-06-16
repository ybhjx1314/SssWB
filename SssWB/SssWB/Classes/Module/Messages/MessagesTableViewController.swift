//
//  MessagesTableViewController.swift
//  SssWB
//
//  Created by yanbo on 16/5/12.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class MessagesTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       visterView?.setupInfo("visitordiscover_image_message", message: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
    }

}
