//
//  HomeTableViewController.swift
//  SssWB
//
//  Created by yanbo on 16/5/12.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
import SVProgressHUD


class HomeTableViewController: BaseTableViewController {

    /// 视图模型
    private lazy var statusListViewModel = StatusListViewModel()
    
    ///  转场动画控制器
    private lazy var photoAnimation  = PhotoBrowserAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightTopBtn)
        
        if  !UserAccountViewModel.sharedUserAccount.userLogon {
            visterView?.setupInfo(nil, message: "关注一些人，回这里看看有什么惊喜")
            return;
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(HMStatusPictureViewSelectedPhotoNotification, object: nil, queue: nil) { [weak self] (noti) -> Void in
            
            guard let pickView = noti.object as? StatusPictureView else {
                return
            }
            
            guard let urls = noti.userInfo![HMStatusPictureViewSelectedPhotoURLsKey] as? [NSURL] else {
                return
            }
            
            guard let indexPath = noti.userInfo![HMStatusPictureViewSelectedPhotoIndexPathKey] as? NSIndexPath else {
                return
            }
            let vc = PhotoBrowserViewController(urls:urls,indexPath: indexPath)
            
            /// 自定义转场动画
            
            // 1.设置代理
            vc.transitioningDelegate = self?.photoAnimation
            // 2.自定义转场动画
            vc.modalPresentationStyle = UIModalPresentationStyle.Custom
            // 3.计算动画位置
            let fromRect = pickView.screenRect(indexPath)
            let toRect  = pickView.fullScreenRect(indexPath)

            
            self?.photoAnimation.prepareAnimator(fromRect, toRect: toRect, url: urls[indexPath.item],picView:pickView)
            
            
            self?.presentViewController(vc, animated: true, completion: nil)
        }
        
        configTableView()
        loadData()
        
    }
    
    private func configTableView(){
        ///  cell分割线
        tableView.separatorStyle  = UITableViewCellSeparatorStyle.None
        ///  估算行高
        tableView.estimatedRowHeight = 200;
        
        tableView.registerClass(ForwardCell.self, forCellReuseIdentifier: statusForwardCellID)
        tableView.registerClass(NormallCell.self, forCellReuseIdentifier: statusNormalCellID)
        ///  刷新
        refreshControl = ZZ_RefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData), forControlEvents: UIControlEvents.ValueChanged)
        ///  加载
        tableView.tableFooterView = pullupView
    }

    @objc private func loadData(){
        refreshControl?.beginRefreshing()
        statusListViewModel.loadStatuses(ispullUpRefresh: pullupView.isAnimating()).subscribeNext({ (reslute) in
            //TODO: --
            self.showPulldownTips((reslute as! NSNumber).integerValue)
            
            }, error: { (error) in
                self.endLoadData()
                printLog(error)
                 SVProgressHUD.showInfoWithStatus("您的网络不给力")
            }) {
                self.endLoadData()
                self.tableView.reloadData()
        }
    }
    
    @objc  func changORcodeVC(){
        presentViewController(UIStoryboard.initialViewController("ORcode"), animated: true, completion: nil)
    }
    
    private func showPulldownTips(count:Int){
        printLog(count)
        let title = count == 0 ? "没有最新微博" : "刷新到 \(count)条微博"
        let height:CGFloat = 44
        let rect = CGRectMake(0, -2 * height, UIScreen.mainScreen().bounds.width, height)
        
        pullDownLabel.text = title
        pullDownLabel.frame = rect
        
        UIView.animateWithDuration(1.2, animations: { 
            
            self.pullDownLabel.frame = CGRectOffset(rect, 0, 3 * height)
            }) { (_) in
                UIView.animateWithDuration(1.2){
                    self.pullDownLabel.frame = rect
                }
                
        }
    }
    
    ///  结束刷新
    private func endLoadData(){
        self.refreshControl?.endRefreshing()
        self.pullupView.stopAnimating()
        
    }
    // MARK: - 懒加载控件
    
    private lazy var pullDownLabel : UILabel = {

        let label = UILabel(title: nil, color: UIColor.whiteColor(), fontSize: 18)
        
        label.backgroundColor = UIColor.orangeColor()
        
        label.textAlignment = NSTextAlignment.Center

        self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        
        return label
    }()
    
    
    // MARK: - 上拉加载控件
    private lazy var pullupView : UIActivityIndicatorView = {
    
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicator.color = UIColor.darkGrayColor()
        return indicator
    
    }()
    
    // MARK: - 扫一扫按钮
    private lazy var rightTopBtn : UIButton = {
       let btn = UIButton()
        
        btn.setImage(UIImage(named: "navigationbar_pop"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named:"navigationbar_pop_highlighted"), forState: UIControlState.Highlighted)
        btn.frame = CGRectMake(0, 0, 30, 30)
        btn.addTarget(self, action: #selector(HomeTableViewController.changORcodeVC), forControlEvents: .TouchUpInside)
        return btn
    }()

}
// MARK: - 首页的扩展
extension HomeTableViewController  {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusListViewModel.statuses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /// 1.取出模型
        let viewModel = statusListViewModel.statuses[indexPath.row]
        
        /// 2 确定cell 类型
        let cell = tableView.dequeueReusableCellWithIdentifier(viewModel.cellID, forIndexPath: indexPath) as! StatusCell
        /// 3 设置cellmodel
        cell.statusViewModel = viewModel
        
        if (indexPath.row == statusListViewModel.statuses.count - 1) && !pullupView.isAnimating() {
            printLog("该加载数据了")
            pullupView.startAnimating()
            loadData()
        }
        
        /// 4 返回
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let viewModel = statusListViewModel.statuses[indexPath.row] as StatusViewModel
        
        if viewModel.rowHeight != 0 {
            
            return viewModel.rowHeight
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(viewModel.cellID) as! StatusCell
        
        viewModel.rowHeight = cell.rowHeight(viewModel)
        
        return viewModel.rowHeight
    }
    
}

