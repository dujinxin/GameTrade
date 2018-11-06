//
//  JXNoticeView.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/29.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit

public enum JXNoticeViewStyle : Int {
    case notice,warning,info,error
}
public enum JXNoticeViewShowPosition {
    case top,middle,bottom
}

public enum JXNoticeViewDuration : Int {
    case long    =  3
    case short   =  1
    case normal  =  2
}

public class JXNoticeView: UIView {

    public var message : String?
    public var font : UIFont = UIFont.boldSystemFont(ofSize: 16)
    
    var position : JXNoticeViewShowPosition = .middle
    var duration : JXNoticeViewDuration = .normal
    
    private var textLabel : UILabel?
    
    lazy private var bgWindow : UIWindow = {
        let window = UIWindow()
        window.frame = UIScreen.main.bounds
        window.windowLevel = UIWindow.Level.alert + 1
        window.backgroundColor = UIColor.clear
        window.isHidden = false
        return window
    }()
    
    public init(text:String) {
        //
        self.message = text
        
        self.textLabel = UILabel()
        textLabel?.numberOfLines = 0
        textLabel?.textColor = UIColor.white
        textLabel?.textAlignment = .center
        textLabel?.layer.shadowColor = UIColor.black.cgColor
        textLabel?.layer.shadowOpacity = 0.8
        textLabel?.layer.shadowRadius = 6
        textLabel?.layer.shadowOffset = CGSize.init(width: 4, height: 4)
  
        self.textLabel?.text = self.message
        
        super.init(frame: CGRect())
        self.layer.cornerRadius = 10.0
        self.alpha = 0.8
        self.backgroundColor = UIColor.black
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismiss(animate:))))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func show() {
        self.show(inView: self.bgWindow)
    }
    public func show(inView view:UIView? ,animate:Bool = true) {
    
        guard let msg = message,msg.isEmpty == false,
              let msgLabel = textLabel else {
            return
        }
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = 7
        let attributes = [NSAttributedString.Key.font:font,NSAttributedString.Key.paragraphStyle:paragraphStyle] as [NSAttributedString.Key : Any]
        let rect = msg.boundingRect(with: CGSize.init(width: UIScreen.main.bounds.width - 60, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading,.usesLineFragmentOrigin], attributes: attributes, context: nil)
        
        msgLabel.frame = CGRect(x: 0, y: 0, width: rect.width + 10, height: rect.height + 10)
        self.frame = CGRect(x: 0, y: 0, width: rect.width + 30, height: rect.height + 30)
        msgLabel.font = font

        let bgView : UIView
        
        if let view = view {
            bgView = view
        }else{
            bgView = self.bgWindow
        }
        var point = self.frame.origin
        
        
        if position == .top {
            point = CGPoint(x: bgView.frame.width / 2, y: 50)
        }else if position == .bottom {
            point = CGPoint(x: bgView.frame.width / 2, y: bgView.frame.height - 60)
        }else if position == .middle {
            point = CGPoint(x: bgView.frame.width / 2, y: bgView.frame.size.height / 2 - 35)
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
    
    @objc public func dismiss(animate:Bool = true) {
        if animate {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: { 
                self.alpha = 0.0
                self.textLabel?.alpha = 0.0
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

}
