//
//  ComposeViewController.swift
//  SssWB
//
//  Created by yanbo on 16/5/31.
//  Copyright © 2016年 yanbo. All rights reserved.
//
//
import UIKit


/// 撰写试图控制器
class ComposeViewController: UIViewController , UITextViewDelegate{
    // MARK: - 表情键盘
    private lazy var emoticonVC :EmoticonViewController = EmoticonViewController { [weak self] (emoticon) in
        self?.textView.insterEmoticon(emoticon)
        print(emoticon.chs)
    }
    // MARK: - 动画约束
    /// 工具栏底部约束
    private var toolbarBottomCons: NSLayoutConstraint?
    /// 照片选择视图高度约束
    private var pictureHeightCons: NSLayoutConstraint?
    /// 文本视图底部约束
    private var textViewBottomCons: NSLayoutConstraint?
    
    
    // MARK: - 监听方法
    /// 发微博
    @objc private func sendStatus() {
        printLog("发送微博")
    }
    ///  切换表情键盘
    @objc private func switchEmoticonKeyboard() {
        printLog(textView.inputView);
        // textView.inputView 如果为nil  表示系统键盘
        textView.resignFirstResponder();
        textView.inputView = (textView.inputView == nil) ? emoticonVC.view : nil
        textView.becomeFirstResponder();
    }
    
    /// 关闭
    @objc private func close() {
        textView.resignFirstResponder()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 输入表情
    @objc private func inputEmoticon() {
        printLog("输入表情")
    }
    
    /// 选择照片
    @objc private func selectPicture() {
        
        // 删除想对 toolbar 的底部约束
        view.removeConstraint(textViewBottomCons!)
        // 相对照片选择视图增加约束
        textViewBottomCons = NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: pictureSelectorVC.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0)
        view.addConstraint(textViewBottomCons!)
        
        textView.resignFirstResponder()
        
        pictureHeightCons?.constant = view.bounds.height * 0.6
        
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - 视图生命周期函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardChanged), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    /// 输入框代理
    func textViewDidChange(textView: UITextView) {
        textLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    /// 键盘通知处理函数
    @objc private func keyboardChanged(n: NSNotification) {
        /// 获取动画曲线
        let curve = n.userInfo![UIKeyboardAnimationCurveUserInfoKey]!.integerValue
        
        let rect = n.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        let duration = n.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        
        toolbarBottomCons?.constant = -UIScreen.mainScreen().bounds.height + rect.origin.y
        
        UIView.animateWithDuration(duration) { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.init(rawValue: curve)!)
            self.view.layoutIfNeeded()
            
        }
        /// 调试动画的代码
        let anima = toolbar.layer.animationForKey("position")
        printLog("动画时长 \(anima?.duration)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if pictureHeightCons?.constant == 0 {
            textView.becomeFirstResponder()
        }
    }
    
    // MARK: - 搭建界面
    override func loadView() {
        view = UIView()
        
        view.backgroundColor = UIColor.whiteColor()
        automaticallyAdjustsScrollViewInsets = false
        
        createNavi()
        createToolbar()
        createTextView()
        createPictureView()
    }
    
    /// 准备照片选择视图
    private func createPictureView() {
        
        addChildViewController(pictureSelectorVC)
        view.insertSubview(pictureSelectorVC.view, belowSubview: toolbar)
        
        let cons = pictureSelectorVC.view.zz_AlignInner(type: zz_LocationType.LeftButtom, referView: view, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 0))
        pictureHeightCons = pictureSelectorVC.view.zz_Constraint(cons, attribute: NSLayoutAttribute.Height)
    }
    
    /// 准备文本视图
    private func createTextView() {
        view.addSubview(textView)
        
        // 自动布局
        let viewDict: [String : AnyObject] = ["top": topLayoutGuide, "tv": textView, "tb": toolbar]
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tv]-0-|", options: [], metrics: nil, views: viewDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[top]-0-[tv]", options: [], metrics: nil, views: viewDict))
        
        textViewBottomCons = NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: toolbar, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        view.addConstraint(textViewBottomCons!)
        
        // 添加占位文字
        textView.addSubview(textLabel)
        textLabel.frame = CGRect(origin: CGPoint(x: 5, y: 8), size: textLabel.bounds.size)
        
       
    }
    
    /// 准备工具栏
    private func createToolbar() {
        view.addSubview(toolbar)
        
        // 设置背景颜色
        toolbar.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        let w = UIScreen.mainScreen().bounds.width
        let cons = toolbar.zz_AlignInner(type: zz_LocationType.LeftButtom, referView: view, size: CGSize(width: w, height: 44))
        toolbarBottomCons = toolbar.zz_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        // 添加按钮
        // 1> 准备按钮数组
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "action": "switchEmoticonKeyboard"],
                            ["imageName": "compose_addbutton_background"]]
        
        // 2> 遍历数组，添加按钮
        var items = [UIBarButtonItem]()
        for item in itemSettings {
            items.append(UIBarButtonItem(imageName: item["imageName"]!, target: self, actionName: item["action"]))
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
    }
    
    /// 准备导航栏
    private func createNavi() {
        // 准备导航栏
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(sendStatus))
        navigationItem.rightBarButtonItem?.enabled = false
        
        // 标题视图
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 32))
        let titleLabel = UILabel(title: "发微博", color: UIColor.darkGrayColor(), fontSize: 15)
        let nameLabel = UILabel(title: UserAccountViewModel.sharedUserAccount.userAccount?.name ?? "", color: UIColor.lightGrayColor(), fontSize: 13)
        titleView.addSubview(titleLabel)
        titleView.addSubview(nameLabel)
        titleLabel.zz_AlignInner(type: zz_LocationType.CenterTop, referView: titleView, size: nil)
        nameLabel.zz_AlignInner(type: zz_LocationType.CenterButtom, referView: titleView, size: nil)
        navigationItem.titleView = titleView
    }
    
    // MARK: - 懒加载控件
    /// 文本视图
    private lazy var textView: UITextView = {
        let tv = UITextView()
        
        tv.delegate = self
        
        tv.font = UIFont.systemFontOfSize(18)
        tv.textColor = UIColor.darkGrayColor()
        
        // 始终保持垂直滚动
        tv.alwaysBounceVertical = true
        // 拖拽关闭键盘
        tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        return tv
    }()
    /// 占位标签
    private lazy var textLabel: UILabel = UILabel(title: "分享新鲜事...", color: UIColor.lightGrayColor(), fontSize: 18)
    /// 工具栏
    private lazy var toolbar = UIToolbar()
    /// 照片选择控制器
    private lazy var pictureSelectorVC = PictureSelectorVC()
}



