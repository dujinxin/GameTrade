//
//  JXNoticeView.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/29.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

enum JXNoticeViewStyle : Int {
    case notice
    case warning
    case info
    case error
}
enum JXNoticeViewShowPosition {
    case top
    case middle
    case bottom
}

enum JXNoticeViewDuration : Int {
    case long    =  3
    case short   =  1
    case normal  =  2
}

class JXNoticeView: UIView {

    //var message : String?
    public var font : UIFont = UIFont.boldSystemFont(ofSize: 16)
    
    public var position : JXNoticeViewShowPosition = .middle
    public var duration : JXNoticeViewDuration = .normal
    
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
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 6
        label.layer.shadowOffset = CGSize.init(width: 4, height: 4)

        return label
    }()

    public init(frame: CGRect = CGRect(),text:String) {
        
        self.message = text
        
//        self.textLabel = UILabel()
//        textLabel?.numberOfLines = 0
//        textLabel?.textColor = UIColor.white
//        textLabel?.textAlignment = .center
//        textLabel?.layer.shadowColor = UIColor.black.cgColor
//        textLabel?.layer.shadowOpacity = 0.8
//        textLabel?.layer.shadowRadius = 6
//        textLabel?.layer.shadowOffset = CGSize.init(width: 4, height: 4)
  
        
        
        super.init(frame: frame)
        
        self.textLabel?.text = text
        
        self.layer.cornerRadius = 10.0
        self.alpha = 0.8
        self.backgroundColor = UIColor.black
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismiss(animate:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 7
        let attributes = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:paragraphStyle]
        let rect = msg.boundingRect(with: CGSize.init(width: UIScreen.main.bounds.width - 70, height: CGFloat.greatestFiniteMagnitude), options: [.usesDeviceMetrics,.usesFontLeading,.usesLineFragmentOrigin], attributes: attributes, context: nil)
        
        msgLabel.frame = CGRect.init(x: 0, y: 0, width: rect.width + 20, height: rect.height + 10)
        self.frame = CGRect.init(x: 0, y: 0, width: rect.width + 20, height: rect.height + 20)
        msgLabel.font = font

        let bgView : UIView
        
        if let view = view {
            bgView = view
        }else{
            bgView = self.bgWindow
        }
        var point = self.frame.origin
        
        
        if position == .top {
            point = CGPoint.init(x: bgView.frame.width / 2, y: 50)
        }else if position == .bottom {
            point = CGPoint.init(x: bgView.frame.width / 2, y: bgView.frame.height - 60)
        }else if position == .middle {
            point = CGPoint.init(x: bgView.frame.width / 2, y: bgView.frame.size.height / 2 - 35)
        }else{
            
        }
        
        self.center = point;
        msgLabel.center = point;
        
        //_textLabel.center = CGPointMake(self.frame.size.width /2, self.frame.size.height /2);
        bgView.addSubview(self)
        bgView.addSubview(msgLabel)

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
