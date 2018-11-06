//
//  JXDefaultView.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/6/7.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

enum JXDefaultViewStyle : Int{
    case none         /*不显示*/
    case logOut       /*未登录*/
    case noNetwork    /*无网络*/
    case dataEmpty    /*无数据*/
}

class JXDefaultView: UIView {
    
    /// 风格类型
    var style : JXDefaultViewStyle = .none{
        didSet {
            setSubViewContent(type: style)
        }
    }
    
    /// detail content include imageName,content text
    var info : [String:String]? {
        didSet {
            guard let imagaName = info?["imageName"],
                let content = info?["content"]
                else {
                    return
            }
            
            imageView.image = UIImage(named: imagaName)
            noticeLabel.text = content
        }
    }
    
    var tapBlock : (()->())?
    
    
    

    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "share_default")
        imageView.backgroundColor = UIColor.yellow
        return imageView
    }()
    
    
    lazy var noticeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.red
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "请检查网络后，重试~~~请检查网络后，重试~~~请检查网络后，重试~~~"
        return label
    }()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(noticeLabel)
        
        //取消
        for v in subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        setNeedsUpdateConstraints()

    }
    
    override func updateConstraints() {
        //imageView
        addConstraint(.init(item: imageView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: self,
                            attribute: .centerX,
                            multiplier: 1.0,
                            constant: 0))
        addConstraint(.init(item: imageView,
                            attribute: .centerY,
                            relatedBy: .equal,
                            toItem: self,
                            attribute: .centerY,
                            multiplier: 1.0,
                            constant: 0))
        //noticeLabel
        let noticeWidth = (self.frame.width - 40)
        print(noticeWidth)
        
        addConstraints([NSLayoutConstraint.init(item: noticeLabel,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: self,
                                                attribute: .centerX,
                                                multiplier: 1.0,
                                                constant: 0),
                        NSLayoutConstraint.init(item: noticeLabel,
                                                attribute: .top,
                                                relatedBy: .greaterThanOrEqual,
                                                toItem: imageView,
                                                attribute: .bottom,
                                                multiplier: 1.0,
                                                constant: 20),
                        NSLayoutConstraint.init(item: noticeLabel,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil,//没有参照物
                            attribute: .notAnAttribute,//没有参照物
                            multiplier: 1.0,
                            constant: noticeWidth)])
        
        super.updateConstraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JXDefaultView {
    
    /// set default content
    ///
    /// - Parameter info: [String:String] include imageName,content
    func setDefaultViewContent(info:[String:String])  {
        
        guard let imagaName = info["imageName"],
            let content = info["content"]
        else {
            return
        }
        
        imageView.image = UIImage(named: imagaName)
        noticeLabel.text = content
    }
    
    func setSubViewContent(type:JXDefaultViewStyle) {
        //
        var imageName : String?
        var content : String?
        
        
        switch type {
        case .none:
            imageName = ""
            content = "不显示"
        case .logOut:
            imageName = "collection_none"
            content = "用户未登录~~~"
        case .dataEmpty:
            imageName = "cart_none"
            content = "空空如也~~~"
        case .noNetwork:
            imageName = "network_none"
            content = "请检查网络后，重试~~~"
            
        }
        
        imageView.image = UIImage(named: imageName!)
        noticeLabel.text = content
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if style == .noNetwork {
            self.tapBlock?()
        }
    }
}

