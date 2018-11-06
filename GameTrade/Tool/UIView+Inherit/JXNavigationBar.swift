//
//  JXNavigationBar.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/10/20.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

class JXNavigationBar: UINavigationBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }￼
    */

    /// 颜色渐变
    lazy var gradientLayer: CAGradientLayer = {
        
        let gradient = CAGradientLayer.init()
        gradient.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        //gradient.locations = [0.5]
        gradient.locations = [0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = CGRect(x: 0, y: 0, width: self.jxWidth, height: self.jxHeight)
        return gradient
    }()
    func imageWithColor(_ color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        var rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavStatusHeight)

        self.subviews.forEach { (v) in
          
            if NSStringFromClass(type(of: v)).contains("UIBarBackground") {
                v.frame = rect
                //隐藏分割线
                v.subviews.forEach({ (subV) in
                    if subV is UIImageView {
                        subV.backgroundColor = UIColor.clear
                    }
                })
//                self.gradientLayer.frame = CGRect(x: 0, y: 0, width: v.jxWidth, height: v.jxHeight)
//                v.layer.addSublayer(self.gradientLayer)
            
            } else if NSStringFromClass(type(of: v)).contains("UINavigationBarContentView") {
                rect.origin.y += kStatusBarHeight
                rect.size.height -= kStatusBarHeight
                v.frame = rect
            }
        }
    }
}
