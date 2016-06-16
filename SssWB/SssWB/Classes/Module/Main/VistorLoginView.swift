//
//  VistorLoginView.swift
//  SssWB
//
//  Created by yanbo on 16/5/18.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

//protocol VistorLoginViewDelegate:NSObjectProtocol {
//    func registerButtonClick();
//    func longinButtonClick();
//}


class VistorLoginView: UIView {
    
//    weak var delegate : VistorLoginViewDelegate?
    
//    @objc private func clickRegist(){
//        delegate?.registerButtonClick()
//    }
    
//    @objc private func clickLogin(){
//        delegate?.longinButtonClick()
//    }
    
    /// 设置未登录的页面
    func setupInfo(imageName:String?, message:String){
        messageLabel.text = message;
        if let imgName = imageName{
            iconView.image = UIImage(named: imgName)
            homeIcon.hidden = true
            sendSubviewToBack(maskIcon)
        } else {
            startAnimation()
        }
    }
    
    private func  startAnimation(){
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 20
        anim.repeatCount =  MAXFLOAT
        anim.removedOnCompletion = false
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///  设置访客视图
    private func setupUI(){
        // 1 添加控件
        addSubview(iconView)
        addSubview(maskIcon)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        // 2 设置布局
        // view1.attr1 = view2.attr2 * multiplier + constant 自动布局核心代码
        iconView.translatesAutoresizingMaskIntoConstraints = false;
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -60))
        homeIcon.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: homeIcon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: homeIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false;
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        // 限制label的宽
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 224))

        registerButton.translatesAutoresizingMaskIntoConstraints = false;
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 35))
        /// VFL
        maskIcon.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[v]-0-|", options: [], metrics: nil, views: ["v":maskIcon]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[v]-(-35)-[regBtn]", options: [], metrics: nil, views: ["v":maskIcon,"regBtn":registerButton]))
        backgroundColor = UIColor(white: 237.0/255.0, alpha: 1)
    }
    // MARK: - 懒加载控件
    // 1 房子 2 图片 3 文字 4 注册按钮 5 登录按钮
    private lazy var iconView : UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    // 2 背景图片
    private lazy var homeIcon : UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    // 遮罩
    private lazy var maskIcon : UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    
    // 3 文字
    private lazy var messageLabel : UILabel = {
       let label = UILabel()
        
        label.text = "关注一些人，回来看看有什么惊喜"
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        
        return label
    }()
    // 4 注册按钮
    
    lazy var registerButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        return btn
    }()
    // 5 登录按钮
    lazy var loginButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)

        return btn
    }()
}
