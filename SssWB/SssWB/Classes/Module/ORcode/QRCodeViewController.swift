//
//  QRCodeViewController.swift
//  SssWB
//
//  Created by yanbo on 16/6/27.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

    @IBOutlet weak var icomImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        createQRcode()
        // Do any additional setup after loading the view.
    }
    
    private func createQRcode(){
        // 建立一个滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        // 设置初值
        qrFilter?.setDefaults()
        
        qrFilter?.setValue("hello word".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), forKey: "inputMessage")
        // 输出图像
        let ciImage = qrFilter?.outputImage
        
        
        // 过滤图像颜色和形变的滤镜
        let colorFilter = CIFilter(name: "CIFalseColor")
        
        colorFilter?.setDefaults()
        
        colorFilter?.setValue(ciImage, forKey: "inputImage")
        colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor0")
        colorFilter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        
        let transform = CGAffineTransformMakeScale(5, 5)
        let showImage = colorFilter?.outputImage?.imageByApplyingTransform(transform)
        let codeImage = UIImage(CIImage: showImage!)
        let avaImage = UIImage(named: "avatar_default_big");
        
        
        self.icomImage.image = insterImage(codeImage, avaterImage: avaImage!)
    }
    
    private func insterImage(codeImage:UIImage , avaterImage:UIImage) -> UIImage {
        let size = codeImage.size
        
        // 开始图像上下文
        UIGraphicsBeginImageContext(size)
        
        // 2 绘制二维码图像
        codeImage.drawInRect(CGRectMake(0, 0, size.width, size.height))
        
        // 3 计算图像宽高
        let w = size.width * 0.22
        let h = size.height * 0.22
        let x = (size.width - w) * 0.5
        let y = (size.height - h) * 0.5
        
        avaterImage.drawInRect(CGRectMake(x, y, w, h))
        
        // 4 去除图像
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
        
    }

}
