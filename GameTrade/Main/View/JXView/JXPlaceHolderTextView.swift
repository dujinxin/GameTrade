//
//  JXPlaceHolderTextView.swift
//  ShoppingGo
//
//  Created by 杜进新 on 2017/8/4.
//  Copyright © 2017年 杜进新. All rights reserved.
//

import UIKit

class JXPlaceHolderTextView: UITextView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var placeHolderText : String = "" {
        didSet{
            self.placeHolderView.text = placeHolderText
            self.placeHolderView.isHidden = placeHolderText.isEmpty
        }
    }
    /// UITextField 默认为R:0 G:0 B:0.1 A:0.22
    var placeHolderColor : UIColor = UIColor(red: 0, green: 0, blue: 0.1, alpha: 0.22) {
        didSet{
            self.placeHolderView.textColor = placeHolderColor
        }
    }
    /// 与文本字体大小一致
    //var placeHolderFont : UIFont!
    
    lazy var placeHolderView: UILabel = {
        let lab = UILabel()
        lab.numberOfLines = 0
        lab.font = self.font
        lab.textColor = self.placeHolderColor
        lab.text = self.placeHolderText
        lab.textAlignment = .left
        lab.isHidden = true
        lab.sizeToFit()
        
        return lab
    }()
    //    convenience init() {
    //        self.init()
    //        setPlaceHolderView()
    //    }
    //
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //        setPlaceHolderView()
    //    }
    
    /// init method
    ///
    /// - Parameters:
    ///   - frame: view frame
    ///   - textContainer: text frame 会自动根据内容调整大小
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setPlaceHolderView()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setPlaceHolderView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //光标的frame为（4，7，2，15.5）
        //输入框 textContainer 不设置的话起始为（0，0），大小根据内容自动调整
        self.placeHolderView.frame = CGRect(origin: CGPoint(x: 6, y: 7), size: CGSize(width:frame.width - 6*2,height:0))
        self.placeHolderView.sizeToFit()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        self.removeObserver(self, forKeyPath: "text")
    }
    func setPlaceHolderView() {
        addSubview(self.placeHolderView)
        sendSubview(toBack: self.placeHolderView)
        self.addObserver(self, forKeyPath: "text", options: [.old,.new], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(placeHolderTextChange(nofiy:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    /// 添加观察者，是为了确保用户设置初始值时placeHolder正常显示
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath,keyPath == "text",let change = change,let newText = change[.newKey] as? String else { return }
        print(newText)
        self.placeHolderView.isHidden = !newText.isEmpty
    }
    /// 添加通知，是为了确保用户修改值时placeHolder正常显示
    @objc func placeHolderTextChange(nofiy:Notification) {
        if placeHolderText.isEmpty == true {
            return
        }
        
        if self.text.isEmpty == true {
            self.placeHolderView.isHidden = false
        }else{
            self.placeHolderView.isHidden = true
        }
    }
    
}
