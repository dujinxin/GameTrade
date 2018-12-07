//
//  JXNoticeImageView.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/6.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

enum JXNoticeImageViewStyle : Int {
    case notice
    case warning
    case info
    case error
}
enum JXNoticeImageViewShowPosition {
    case top
    case middle
    case bottom
}

enum JXNoticeImageViewDuration : Int {
    case long    =  3
    case short   =  1
    case normal  =  2
}

class JXNoticeImageView: UIView {
    
    //var message : String?
    public var font : UIFont = UIFont.boldSystemFont(ofSize: 16)
    
    public var position : JXNoticeImageViewShowPosition = .middle
    public var duration : JXNoticeImageViewDuration = .normal
    
    //private var textLabel : UILabel?
    
    public var message: String? {
        didSet {
            self.textLabel?.text = message
        }
    }
    
    lazy private var bgWindow : UIWindow = {
        let window = UIWindow()
        window.frame = UIScreen.main.bounds
        window.windowLevel = UIWindow.Level.alert + 1
        window.backgroundColor = UIColor.clear
        window.isHidden = false
        return window
    }()
    
    private lazy var textLabel: UILabel? = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.white
        label.textAlignment = .center
//        label.layer.shadowColor = UIColor.black.cgColor
//        label.layer.shadowOpacity = 0.8
//        label.layer.shadowRadius = 6
//        label.layer.shadowOffset = CGSize.init(width: 4, height: 4)
        
        return label
    }()
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "img-right")
        return iv
    }()
    public init(frame: CGRect = CGRect(),text:String) {
        
        self.message = text
   
        super.init(frame: frame)
        
        self.frame = CGRect.init(x: 0, y: 0, width: 158, height: 158)
        
        self.textLabel?.text = text
        
        self.backgroundColor = app_style <= 1 ? UIColor.rgbColor(rgbValue: 0x22222C, alpha: 0.6) : JXFfffffColor
        
        self.layer.cornerRadius = 2
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowColor = JX10101aShadowColor.cgColor
        
        self.textLabel?.textColor = JXMainColor
        self.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        //self.layer.cornerRadius = 10.0
        //self.alpha = 0.8
        //self.backgroundColor = UIColor.black
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismiss(animate:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.frame = CGRect(x: 38, y: 24, width: 82, height: 82)
        self.textLabel?.frame = CGRect(x: 0, y: self.imageView.jxBottom + 15, width: bounds.width, height: 20)
    }
    func show() {
        self.show(inView: self.bgWindow)
    }
    func show(inView view:UIView? ,animate:Bool = true) {
        
        guard let msg = message,msg.isEmpty != true else {
            return
        }
        guard let msgLabel = textLabel  else {
            assert(true, "noticeView textLabel can not be nil")
            return
        }
        
        
        
        msgLabel.font = font
        
        let bgView : UIView
        
        if let view = view {
            bgView = view
        }else{
            bgView = self.bgWindow
        }
        var point = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        
        
//        if position == .top {
//            point = CGPoint.init(x: bgView.frame.width / 2, y: 50)
//        }else if position == .bottom {
//            point = CGPoint.init(x: bgView.frame.width / 2, y: bgView.frame.height - 60)
//        }else if position == .middle {
//            point = CGPoint.init(x: bgView.frame.width / 2, y: bgView.frame.size.height / 2 - 35)
//        }else{
//
//        }
        
        self.center = point;
//        msgLabel.center = point;
        
        //_textLabel.center = CGPointMake(self.frame.size.width /2, self.frame.size.height /2);
        self.addSubview(self.imageView)
        self.addSubview(self.textLabel!)
        bgView.addSubview(self)
//        bgView.addSubview(msgLabel)
//        bgView.addSubview(self.imageView)
        
        if (animate) {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.alpha = 0.8
                msgLabel.alpha = 1.0
            }, completion: { (finished) in
                //
            })
        }
        self.perform(#selector(dismiss(animate:)), with: nil, afterDelay: TimeInterval(duration.rawValue))
    }
    
    @objc func dismiss(animate:Bool = true) {
        if animate {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
                self.alpha = 0.0
                //self.textLabel?.alpha = 0.0
            }, completion: { (finished) in
                self.clearInfo()
            })
        }else{
            clearInfo()
        }
    }
    func clearInfo() {
        textLabel?.removeFromSuperview()
        self.removeFromSuperview()
        bgWindow.isHidden = true
    }
    deinit {
        
    }
    
}
