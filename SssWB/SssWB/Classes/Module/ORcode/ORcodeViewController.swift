//
//  ORcodeViewController.swift
//  SssWB
//
//  Created by 闫波 on 16/6/22.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
import AVFoundation

class ORcodeViewController: UIViewController{
    /// 动画视图的高度
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    /// 动画视图的宽度
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    /// 动画视图上边约束
    @IBOutlet weak var anmiationLayout: NSLayoutConstraint!
    /// tabbar
    @IBOutlet weak var tabbar: UITabBar!
    // MARK: - 视图生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbar.selectedItem = tabbar.items![0]
    }
    
    @IBOutlet weak var sacImageView: UIImageView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        barAnimation()
        scan()
    }
    ///  冲击波动画
    private func barAnimation(){
        self.anmiationLayout.constant = -self.viewHeight.constant
         view.layoutIfNeeded()
        
        UIView.animateWithDuration(2.0) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.anmiationLayout.constant = self.viewHeight.constant
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func close(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - 二维码扫描
    // 1. 拍摄会话
    lazy var session:AVCaptureSession = {
       return AVCaptureSession()
    }()
    
    // 2. 输入设备
    lazy var videoInpute:AVCaptureDeviceInput? = {
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        if device == nil {
            return nil
        }
        
        return try! AVCaptureDeviceInput(device:device)
    }()
    // 3. 输出设备
    lazy var dataOutput : AVCaptureMetadataOutput = {
       return AVCaptureMetadataOutput()
    }()
    
    // 4. 预览视图
    lazy var preViewLayer : AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = self.view.bounds
        return layer 
    }()
    
    // 5 绘图视图
    lazy var drawLayer : CALayer = {
        let layer = CALayer()
        
        layer.frame = self.view.bounds
        
        return layer
    }()
    
    // 开始扫描
    private func scan(){
        // 判断能否添加输入设备
        if !session.canAddInput(videoInpute) {
            print("无法添加输入设备")
            return
        }
        
        if !session.canAddOutput(dataOutput) {
            print("无法添加输出设备")
            return
        }
        // 添加输入输出设备
        session.addInput(videoInpute)
        session.addOutput(dataOutput)
        // 设置支持的输出格式的类型 以及代理
        dataOutput.metadataObjectTypes = dataOutput.availableMetadataObjectTypes
        dataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        // 开始
        session.startRunning()
        
        // 添加预览图层
        view.layer.insertSublayer(drawLayer, atIndex: 0)
        view.layer.insertSublayer(preViewLayer, atIndex: 0)
    }
}

extension ORcodeViewController : AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        clearDrawLayer()
        
        for codeObject in metadataObjects {
            if let obj = codeObject as? AVMetadataMachineReadableCodeObject {
                let object = preViewLayer.transformedMetadataObjectForMetadataObject(obj) as! AVMetadataMachineReadableCodeObject
                drawCorners(object)
            }
        }
    
    }
    
    private func clearDrawLayer(){
        if drawLayer.sublayers == nil {
            return
        }
        
        for l in drawLayer.sublayers! {
            l.removeFromSuperlayer()
        }
    }
    
    private func drawCorners(codeObject:AVMetadataMachineReadableCodeObject) {
        // shape layer 专门用来画图的图层
        
        if codeObject.corners.count == 0 {
            return
        }
        
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clearColor().CGColor
        layer.lineWidth = 4.0
        layer.strokeColor = UIColor.greenColor().CGColor
        
        // 设置路径
        layer.path = createPath(codeObject.corners).CGPath
        drawLayer.addSublayer(layer)
    }
    
    private func createPath(points:NSArray) ->UIBezierPath {
        let path = UIBezierPath()
        var point = CGPoint()
        
        var index = 0
        
        // 1.移动到第一个点
        CGPointMakeWithDictionaryRepresentation(points[index++] as! CFDictionaryRef, &point)
        path.moveToPoint(point)
        
        // 2循环便利剩余的点
        while index < points.count {
            CGPointMakeWithDictionaryRepresentation(points[index++] as! CFDictionaryRef, &point)
            path.addLineToPoint(point)
        }
        // 3 关闭路径 从起始点到终点
        path.closePath()
        
        return path
    }
}


extension ORcodeViewController :UITabBarDelegate{
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        viewHeight.constant = item.tag == 1 ? viewWidth.constant * 0.5 :viewWidth.constant
        sacImageView.layer.removeAllAnimations()
        barAnimation()
    }
    
}