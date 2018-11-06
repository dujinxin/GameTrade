//
//  JXInputTextView.swift
//  Star
//
//  Created by 杜进新 on 2018/5/30.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

public enum JXInputTextViewStyle {
    case none          //控件不带输入框
    case hidden        //hidden
    case bottom        //bottom
//    /**
//     top view of keyboard
//     */
//    case none
//    case normal        //cancel & comfirm
//    case textView      //
//    case custom        //
}
public enum JXInputTextViewApplication {
    case comment
    case chat
}
@objc public protocol JXInputTextViewDelegate {
    @objc optional func inputTextViewConfirm(inputTextView :JXInputTextView, object:String?)
}

private let inputViewMinHeight : CGFloat = 40
//private let inputViewMaxHeight : CGFloat = 90
private let inputViewTopMargin : CGFloat = 10
private let inputViewBottomMargin : CGFloat = 10
private let inputViewMargin : CGFloat = kScreenWidth * 0.05
private let inputViewWidth : CGFloat = UIScreen.main.bounds.width - 2 * inputViewMargin

private let keyWindowWidth : CGFloat = UIScreen.main.bounds.width
private let keyWindowHeight : CGFloat = UIScreen.main.bounds.height
private let additionalBottomHeight : CGFloat = (deviceModel == .iPhoneX) ? 34 : 0

public class JXInputTextView: JXView {
    
    public var style: JXInputTextViewStyle = .none
    public var apply : JXInputTextViewApplication = .comment
    public var delegate : JXInputTextViewDelegate?
    public var sendBlock : ClickBlock?
    public var limitWords : Int  =  0                     //限制字数，0默认不限制
    public var limitLines : Int  =  4                     //限制行数，默认限制4行
    public var placeHolder: String? {
        didSet {
            self.textView.placeHolderText = placeHolder ?? ""
        }
    }
    public var text: String? {
        didSet {
            self.textView.text = text
        }
    }
    public var topBarHeight: CGFloat = 60 {
        didSet {
            
        }
    }
    public var font: UIFont = UIFont.systemFont(ofSize: 14){
        didSet {
            self.textView.font = font
        }
    }
    public var textColor: UIColor = UIColor.darkGray{
        didSet {
            self.textView.textColor = textColor
        }
    }
    //MARK:public methods
    public func show() {
        let superView : UIView
        if self.style == .bottom {
            guard let v = self.superview else {
                print(("(bottom position) self should be added to superview first"))
                return
            }
            superView = v
        } else {
            self.clearInfo()
            superView = self.bgWindow!
            superView.addSubview(self)
            superView.addSubview(self.tapControl)
            superview?.insertSubview(self.tapControl, belowSubview: self)
        }
        
        switch self.style {
        case .hidden:
            self.textView.becomeFirstResponder()
        default:
            print("由输入框来触发")
        }
    }
    public func dismiss() {
        self.contentView?.resignFirstResponder()
    }
    //MARK: private properties
    private var contentView : UIView?
    private var keyboardRect = CGRect()
    private var animateDuration = 0.25
    private var isKeyboardShow = false
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.white
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(JX333333Color, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(tapClick), for: .touchUpInside)
        return btn
    }()
    private lazy var bgWindow : UIWindow? = {
        let window = UIApplication.shared.keyWindow
        window?.frame = UIScreen.main.bounds
        window?.backgroundColor = UIColor.clear
        window?.isHidden = false
        return window
    }()
    
    private lazy var tapControl : UIControl = {
        let control = UIControl()
        control.frame = UIScreen.main.bounds
        control.backgroundColor = UIColor.black
        control.alpha = 0.2
        control.addTarget(self, action: #selector(tapClick), for: .touchUpInside)

        return control
    }()
    private lazy var textView: JXPlaceHolderTextView = {
        let text = JXPlaceHolderTextView()
        text.layer.cornerRadius = 3
        text.delegate = self
        text.layer.masksToBounds = true
        text.layer.borderColor = UIColor.gray.cgColor
        text.layer.borderWidth = 1.0
        text.returnKeyType = .send
        text.enablesReturnKeyAutomatically = true
        
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = UIColor.darkText
        return text
    }()
    //MARK:private methods
    private func setTopBar(style:JXInputTextViewStyle) {
        self.style = style
        
        switch style {
        case .none:
            print("none")
        case .hidden, .bottom:
            self.contentView = self.textView
            self.addSubview(self.contentView!)
            self.addObserver(self, forKeyPath: "text", options: [.old,.new], context: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(textChange(nofiy:)), name: UITextView.textDidChangeNotification, object: nil)
        }
        self.setPosition(hidden: style != .bottom)
    }
    private func setPosition(hidden:Bool) {
        //如果为iPhoneX，则把底部的34空间让出来
        let h : CGFloat = topBarHeight + additionalBottomHeight
        if hidden == true {
            self.frame = CGRect.init(x: 0, y: keyWindowHeight, width: keyWindowWidth, height: topBarHeight)
        } else {
            self.frame = CGRect.init(x: 0, y: keyWindowHeight - h, width: keyWindowWidth, height: h)
        }
    }
    private func setKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notify:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notify:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc private func tapClick() {
        self.dismiss()
    }
    fileprivate func clearInfo() {
        self.tapControl.removeFromSuperview()
        self.removeFromSuperview()
    }
    //MARK:system methods
    public init(frame: CGRect, style:JXInputTextViewStyle = .none,completion:ClickBlock?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.groupTableViewBackground
        
        self.setTopBar(style: style)
        self.setKeyBoardObserver()
        self.sendBlock = completion
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.contentView?.frame = CGRect(x: inputViewMargin, y: inputViewTopMargin, width: inputViewWidth, height: topBarHeight - inputViewTopMargin - inputViewBottomMargin)
    }
}
extension JXInputTextView {
    @objc func keyboardWillShow(notify:Notification) {
        print("notify = ","show")
        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else {
            return
        }
        self.animateDuration = animationDuration
        self.keyboardRect = rect

        UIView.animate(withDuration: animationDuration, animations: {
            self.frame = CGRect(x: 0, y: keyWindowHeight - self.topBarHeight - self.keyboardRect.height, width: keyWindowWidth, height: self.topBarHeight)
            self.tapControl.alpha = 0.2
        }) { (finish) in
            //
        }
    }
    @objc func keyboardWillHide(notify:Notification) {
        print("notify = ","hide")
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
//        self.animateDuration = animationDuration
//        self.keyboardRect = rect
        UIView.animate(withDuration: animationDuration, animations: {
            //如果为iPhoneX，则把底部的34空间让出来
            let h : CGFloat = self.topBarHeight + additionalBottomHeight
            if self.style == .bottom {
                self.frame = CGRect.init(x: 0, y: keyWindowHeight - h, width: keyWindowWidth, height: h)
            } else {
                self.frame = CGRect.init(x: 0, y: keyWindowHeight, width: keyWindowWidth, height: h)
            }
            self.tapControl.alpha = 0
        }) { (finish) in
            if self.style == .hidden {
                self.clearInfo()
            } else if self.style == .bottom{
                
            } else {
                self.clearInfo()
            }
        }
    }
    @objc func keyboardDidShow(notify:Notification) {
        self.isKeyboardShow = true
    }
    @objc func keyboardDidHide(notify:Notification) {
        self.isKeyboardShow = false
    }
    
    /// 添加观察者，是为了确保用户设置初始值时placeHolder正常显示
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath,keyPath == "text",let change = change,let newText = change[.newKey] as? String else { return }
        self.automaticallySet(self.textView, newText)
        print("observeValue")
    }
    /// 添加通知，是为了确保用户修改值时placeHolder正常显示
    @objc func textChange(nofiy:Notification) {
        guard
            let view = nofiy.object as? JXPlaceHolderTextView,let string = view.text else{
            return
        }
        self.automaticallySet(view, string)
        //self.layoutIfNeeded()
    }
    func automaticallySet(_ textView:JXPlaceHolderTextView,_ string:String) {
        let size = string.calculate(width: textView.frame.width, fontSize: self.font.pointSize)
        let height = size.height + textView.textContainerInset.top + textView.textContainerInset.bottom
        let inputViewMaxHeight = self.font.lineHeight * CGFloat(limitLines)
        
        if height <= inputViewMinHeight {
            self.topBarHeight = inputViewTopMargin + inputViewBottomMargin + inputViewMinHeight
        }else if height >= inputViewMaxHeight{
            self.topBarHeight = inputViewTopMargin + inputViewBottomMargin + inputViewMaxHeight
        } else {
            self.topBarHeight = inputViewTopMargin + inputViewBottomMargin + height
        }
        UIView.animate(withDuration: animateDuration, animations: {
            self.frame = CGRect(x: 0, y: keyWindowHeight - self.topBarHeight - self.keyboardRect.height, width: keyWindowWidth, height: self.topBarHeight)
        }) { (finish) in
            //
        }
    }
}
extension JXInputTextView : UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //限制字数不可以限制回车，删除键，所以要优先响应，然后再限制
        //删除键
        if text == "" {
            return true
        }
        //return键 收键盘
        if text == "\n" {
            if let target = delegate {
                target.inputTextViewConfirm!(inputTextView: self, object: textView.text)
            }
            if let block = sendBlock {
                block(self,textView.text)
            }
            textView.text = ""                        //发送后清除内容
            if self.apply == .comment {
                self.automaticallySet(textView as! JXPlaceHolderTextView, textView.text)
                textView.resignFirstResponder()       //评论需要收起键盘，聊天则不用收
            }
            return false
        }
        //限制输入字符数
        if limitWords > 0 {
            if let string = textView.text, string.count > limitWords - 1{
                textView.text = String(string.prefix(upTo: string.index(string.startIndex, offsetBy: limitWords)))
                //textView.text = string.substring(to: string.index(string.startIndex, offsetBy: 500))
                let notice = JXNoticeView.init(text: "字符个数不能大于\(limitWords)")
                notice.show()
                return false
            }
        }
        return true
    }
}
