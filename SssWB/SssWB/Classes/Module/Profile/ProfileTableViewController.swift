//
//  ProfileTableViewController.swift
//  SssWB
//
//  Created by yanbo on 16/5/12.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        visterView?.setupInfo("visitordiscover_image_profile", message: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
    }

}
