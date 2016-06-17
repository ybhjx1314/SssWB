//
//  PictureSelectorVC.swift
//  PictureSelector
//
//  Created by yanbo on 16/6/1.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit
/// 重用标识符
private let PictureSelectorCellID = "PictureSelectorCellID"
/// 最大个数
let PictureMaxCount = 9

class PictureSelectorVC: UICollectionViewController ,PictureSelectorCellDelegate{
    /// 照片数组
    lazy var  pictures = [UIImage]()
    
    private var currentIndex = 0
    
    // MARK: - 代理方法
    private func PictureSelectorCellClickRemoveBtn(cell: PictureSelectorCell) {
        ///  删除图片 
        
        if let indexPath = collectionView?.indexPathForCell(cell) where indexPath.item < pictures.count {
            /// 清楚数组
            pictures.removeAtIndex(indexPath.item)
            collectionView?.reloadData()
        }
        
    }
    
    init(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = UIColor(white: 0.97, alpha: 1)
        // Register cell classes
        self.collectionView!.registerClass(PictureSelectorCell.self, forCellWithReuseIdentifier: PictureSelectorCellID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


    // MARK: - UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pictures.count + (pictures.count == PictureMaxCount ? 0 : 1)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PictureSelectorCellID, forIndexPath: indexPath) as! PictureSelectorCell
        //  设置代理
        cell.pictureDelegate = self
        // 设置图形
        cell.image = (indexPath.item < pictures.count) ? pictures[indexPath.item] :nil
    
        return cell
    }
    ///  点击事件
    ///
    ///  - parameter collectionView: collectionView
    ///  - parameter indexPath:      indexPath
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        /// Camera 可以访问相机 PhotoLibrary图片库 SavedPhotosAlbum 相册
        if !UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
            print("无法访问照片库")
            return
        }
        
        currentIndex = indexPath.item
        
        let vc = UIImagePickerController()
        
        vc.delegate = self
        
        presentViewController(vc, animated: true, completion: nil)
        
    }

}


extension PictureSelectorVC :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    ///  选择照片的代理
    ///
    ///  - parameter picker:      picker 控制器
    ///  - parameter image:       选中的图向
    ///  - parameter editingInfo: 编辑字典
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        let scaleImage = image.sacleImageToWidth(300)
        
        if currentIndex < pictures.count {
            pictures[currentIndex] = scaleImage
        } else {
            
            pictures.append(scaleImage)
        }
        
        
        collectionView?.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

/// 图片选择代理
private protocol PictureSelectorCellDelegate : NSObjectProtocol{
    ///  删除按钮点击事件
    func PictureSelectorCellClickRemoveBtn(cell:PictureSelectorCell)
}

/// 选择照片的cell
private class PictureSelectorCell :UICollectionViewCell{
    
    var image : UIImage? {
        didSet {
            if image != nil {
                pictureAddBtn.setImage(image, forState: .Normal)
            } else {
                pictureAddBtn.setImage(UIImage(named: "compose_pic_add"), forState: .Normal)
            }
            removePicBtn.hidden = image == nil
        }
    }
    
    
    weak var pictureDelegate : PictureSelectorCellDelegate?
    
    
    // MARK: - 点击事件
    @objc private func clickRemoveBtn(){
        pictureDelegate?.PictureSelectorCellClickRemoveBtn(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    private func setupUI(){
        contentView.addSubview(pictureAddBtn)
        contentView.addSubview(removePicBtn)
        
        pictureAddBtn.frame = bounds
        removePicBtn.translatesAutoresizingMaskIntoConstraints = false
        let viewDict = ["btn":removePicBtn]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[btn]-0-|", options: [], metrics: nil, views: viewDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[btn]", options: [], metrics: nil, views: viewDict))
        pictureAddBtn.userInteractionEnabled = false
        removePicBtn.addTarget(self, action: #selector(clickRemoveBtn), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)    has not been implemented")
    }
    
    // MARK: - 懒加载控件
    ///  添加照片按钮
    private lazy var pictureAddBtn : UIButton = {
        let button = UIButton(imageName: "compose_pic_add")
        
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        return button
    }()
    ///  删除照片
    private lazy var removePicBtn :UIButton = UIButton(imageName: "compose_photo_close")
}
