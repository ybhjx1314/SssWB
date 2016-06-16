//
//  DiscoverTableViewController.swift
//  SssWB
//
//  Created by yanbo on 16/5/12.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visterView?.setupInfo("visitordiscover_image_profile", message: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
    }

}
