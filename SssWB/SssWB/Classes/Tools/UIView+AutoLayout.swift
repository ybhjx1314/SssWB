//
//  zz_Location.swift
//  SssWB
//
//  Created by yanbo on 16/5/25.
//  Copyright © 2016年 yanbo. All rights reserved.
//

import UIKit

///  视图内部枚举类型
///
///  - LeftTop:      左上
///  - RightTop:     右上
///  - CenterTop:    中上
///  - LeftCenter:   左中
///  - RightCenter:  右中
///  - CenterCenter: 中中
///  - LeftButtom:   左下
///  - RightButtom:  右下
///  - CenterButtom: 中下
public enum zz_LocationType{
    case LeftTop
    case RightTop
    case CenterTop
    case LeftCenter
    case RightCenter
    case CenterCenter
    case LeftButtom
    case RightButtom
    case CenterButtom
    
    private func layoutAttributes(isInner:Bool,isVertical: Bool) -> zz_LayoutAttributes{
        let attributes = zz_LayoutAttributes()
        switch self {
        case .LeftTop:
            attributes.horizontals(.Left, to: .Left).verticals(.Top, to: .Top)
            // 在内部
            if isInner {
                return attributes
                // 在外部
            } else if isVertical {
                return attributes.verticals(.Bottom, to: .Top)
            } else {
                return attributes.horizontals(.Right, to: .Left)
            }
        case .RightTop:
            attributes.horizontals(.Right, to: .Right).verticals(.Top, to: .Top)
            if isInner {
                return attributes
            } else if isVertical {
                return attributes.verticals(.Bottom, to: .Top)
            } else {
                return attributes.horizontals(.Left, to: .Right)
            }
        // 仅限在内部参考
        case .CenterTop:
            attributes.horizontals(.CenterX, to: .CenterX).verticals(.Top, to: .Top)
            return isInner ? attributes : attributes.verticals(.Bottom, to: .Top)
        case .LeftCenter:
            attributes.horizontals(.Left, to: .Left).verticals(.CenterY, to: .CenterY)
            return isInner ? attributes : attributes.horizontals(.Right, to: .Left)
        case .RightCenter:
            attributes.horizontals(.Right, to: .Right).verticals(.CenterY, to: .CenterY)
            return isInner ? attributes : attributes.horizontals(.Left, to: .Right)
        case .CenterCenter:
            return zz_LayoutAttributes(horizontal: .CenterX, referHorizontal: .CenterX, vertical: .CenterY, referVertical: .CenterY)
        case .LeftButtom: 
            attributes.horizontals(.Left, to: .Left).verticals(.Bottom, to: .Bottom)
            
            if isInner {
                return attributes
            } else if isVertical {
                return attributes.verticals(.Top, to: .Bottom)
            } else {
                return attributes.horizontals(.Right, to: .Left)
            }

        case .RightButtom: 
            attributes.horizontals(.Right, to: .Right).verticals(.Bottom, to: .Bottom)
            
            if isInner {
                return attributes
            } else if isVertical {
                return attributes.verticals(.Top, to: .Bottom)
            } else {
                return attributes.horizontals(.Left, to: .Right)
            }

        case .CenterButtom:
            attributes.horizontals(.CenterX, to: .CenterX).verticals(.Bottom, to: .Bottom)
            return isInner ? attributes : attributes.verticals(.Top, to: .Bottom)
        }
    }
    
    
}

extension UIView {
    ///  填充试图
    ///
    ///  - parameter referView: 参考试图
    ///  - parameter insets:    间距
    ///
    ///  - returns: 约束数组
    public func zz_fill(referView:UIView , insets:UIEdgeInsets = UIEdgeInsetsZero)->[NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(insets.left)-[subView]-\(insets.right)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["subView":self])
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(insets.top)-[sub]-\(insets.bottom)-|", options: NSLayoutFormatOptions.AlignAllBaseline, metrics: nil, views: ["sub":self])
        
        superview?.addConstraints(cons)
        
        return cons
    }
    ///  参照参考视图内部对齐
    ///
    ///  - parameter type:      对齐方式
    ///  - Parameter referView: 参考视图
    ///  - Parameter size:      视图大小，如果是 nil 则不设置大小
    ///  - Parameter offset:    偏移量，默认是 CGPoint(x: 0, y: 0)
    ///
    ///  - returns: 约束数组
    public func zz_AlignInner(type type:zz_LocationType ,referView:UIView , size:CGSize?, offset :CGPoint = CGPointZero ) ->[NSLayoutConstraint]{
        
        return zz_AlignLayout(referView, attributes: type.layoutAttributes(true, isVertical: true), size: size, offset: offset)
    }
    
    ///  参照参考视图垂直对齐
    ///
    ///  - parameter type:      对齐方式
    ///  - parameter referView: 参考视图
    ///  - parameter size:      视图大小，如果是 nil 则不设置大小
    ///  - parameter offset:    偏移量，默认是 CGPoint(x: 0, y: 0)
    ///
    ///  - returns: 约束数组
    public func zz_AlignVertical(type type: zz_LocationType, referView: UIView, size: CGSize?, offset: CGPoint = CGPointZero) -> [NSLayoutConstraint] {
        return zz_AlignLayout(referView, attributes: type.layoutAttributes(false, isVertical: true), size: size, offset: offset)
    }

    ///  参照参考视图水平对齐
    ///
    ///  - parameter type:      对齐方式
    ///  - parameter referView: 参考视图
    ///  - parameter size:      视图大小，如果是 nil 则不设置大小
    ///  - parameter offset:    偏移量，默认是 CGPoint(x: 0, y: 0)
    ///
    ///  - returns: 约束数组
    public func zz_AlignHorizontal(type type: zz_LocationType, referView: UIView, size: CGSize?, offset: CGPoint = CGPointZero) -> [NSLayoutConstraint] {
        return zz_AlignLayout(referView, attributes: type.layoutAttributes(false, isVertical: false), size: size, offset: offset)
    }
    
    public func zz_HorizontalTile(views: [UIView], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        assert(!views.isEmpty, "views should not be empty")
        var cons = [NSLayoutConstraint]()
        
        let firstView = views[0]
        firstView.zz_AlignInner(type: zz_LocationType.LeftTop, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: firstView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -insets.bottom))
        // 添加后续视图的约束
        var preView = firstView
        for i in 1..<views.count {
            let subView = views[i]
            cons += subView.zz_sizeConstraints(firstView)
            subView.zz_AlignHorizontal(type: zz_LocationType.RightTop, referView: preView, size: nil, offset: CGPoint(x: insets.right, y: 0))
            preView = subView
        }
        
        let lastView = views.last!
        cons.append(NSLayoutConstraint(item: lastView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -insets.right))
        
        addConstraints(cons)
        return cons
    }
    
    ///  在当前视图内部垂直平铺控件
    ///
    ///  - parameter views:  子视图数组
    ///  - parameter insets: 间距
    ///
    ///  - returns: 约束数组
    public func zz_VerticalTile(views: [UIView], insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        
        assert(!views.isEmpty, "views should not be empty")
        
        var cons = [NSLayoutConstraint]()
        
        let firstView = views[0]
        firstView.zz_AlignInner(type: zz_LocationType.LeftTop, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: firstView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -insets.right))
        
        // 添加后续视图的约束
        var preView = firstView
        for i in 1..<views.count {
            let subView = views[i]
            cons += subView.zz_sizeConstraints(firstView)
            subView.zz_AlignVertical(type: zz_LocationType.LeftButtom, referView: preView, size: nil, offset: CGPoint(x: 0, y: insets.bottom))
            preView = subView
        }
        
        let lastView = views.last!
        cons.append(NSLayoutConstraint(item: lastView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -insets.bottom))
        
        addConstraints(cons)
        
        return cons
    }
    
    ///  从约束数组中查找指定 attribute 的约束
    ///
    ///  - parameter constraintsList: 约束数组
    ///  - parameter attribute:       约束属性
    ///
    ///  - returns: attribute 对应的约束
    public func zz_Constraint(constraintsList: [NSLayoutConstraint], attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        for constraint in constraintsList {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == attribute {
                return constraint
            }
        }
        
        return nil
    }

    
    
    // MARK: - 私有函数
    // 实现的具体
    private func zz_AlignLayout(referView:UIView ,attributes : zz_LayoutAttributes ,size:CGSize?,offset : CGPoint) -> [NSLayoutConstraint]{
        translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        
        cons += zz_positionConstraints(referView, attributes: attributes, offset: offset)
        
        if size != nil {
            cons += zz_sizeConstraints(size!)
        }
        
        superview?.addConstraints(cons)
        
        return cons

    }
    
    ///  尺寸约束数组
    ///
    ///  - parameter size: 视图大小
    ///
    ///  - returns: 约束数组
    private func zz_sizeConstraints(size: CGSize) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: size.width))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: size.height))
        
        return cons
    }
    ///  尺寸约束数组
    ///
    ///  - parameter referView: 参考视图，与参考视图大小一致
    ///
    ///  - returns: 约束数组
    private func zz_sizeConstraints(referView: UIView) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: referView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: referView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        return cons
    }

    
    ///  位置约束数组
    ///
    ///  - parameter referView:  参考视图
    ///  - parameter attributes: 参照属性
    ///  - parameter offset:     偏移量
    ///
    ///  - returns: 约束数组
    private func zz_positionConstraints(referView: UIView, attributes: zz_LayoutAttributes, offset: CGPoint) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.horizontal, relatedBy: NSLayoutRelation.Equal, toItem: referView, attribute: attributes.referHorizontal, multiplier: 1.0, constant: offset.x))
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.vertical, relatedBy: NSLayoutRelation.Equal, toItem: referView, attribute: attributes.referVertical, multiplier: 1.0, constant: offset.y))
        
        return cons
    }
    
}

///  布局属性
private final class zz_LayoutAttributes {
    var horizontal      : NSLayoutAttribute
    var referHorizontal : NSLayoutAttribute
    var vertical        : NSLayoutAttribute
    var referVertical   : NSLayoutAttribute
    
    init() {
        horizontal      = NSLayoutAttribute.Left
        referHorizontal = NSLayoutAttribute.Left
        vertical        = NSLayoutAttribute.Top
        referVertical   = NSLayoutAttribute.Top
    }
    
    init(horizontal:NSLayoutAttribute ,referHorizontal:NSLayoutAttribute,vertical:NSLayoutAttribute,referVertical:NSLayoutAttribute){
        self.horizontal = horizontal
        self.referHorizontal = referHorizontal
        self.vertical = vertical
        self.referVertical = referVertical
    }
    
    ///  类方法实例化
    ///
    ///  - parameter from: 起始位置
    ///  - parameter to:   结束位置
    ///
    ///  - returns: self
    private func horizontals(from: NSLayoutAttribute, to: NSLayoutAttribute)-> Self{
        horizontal = from
        referHorizontal = to
        return self
    }
    
    ///  类方法实例化
    ///
    ///  - parameter from: 起始位置
    ///  - parameter to:   结束位置
    ///
    ///  - returns: self
    private func verticals(from:NSLayoutAttribute, to:NSLayoutAttribute) ->Self{
        vertical = from
        referVertical = to
        return self
        
    }
}