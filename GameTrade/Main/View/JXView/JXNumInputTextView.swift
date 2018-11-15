//
//  JXNumInputTextView.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/13.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import JXFoundation

@objc protocol JXNumInputTextViewDelegate {
    @objc optional func inputTextViewConfirm(inputTextView :JXNumInputTextView, object:String?)
}
private let inputViewTopBarHeight : CGFloat = 44

private let inputViewMinHeight : CGFloat = 40
//private let inputViewMaxHeight : CGFloat = 90
private let inputViewTopMargin : CGFloat = 10
private let inputViewBottomMargin : CGFloat = 10
private let inputViewMargin : CGFloat = kScreenWidth * 0.05
private let inputViewWidth : CGFloat = UIScreen.main.bounds.width - 2 * inputViewMargin

private let keyWindowWidth : CGFloat = UIScreen.main.bounds.width
private let keyWindowHeight : CGFloat = UIScreen.main.bounds.height
private let additionalBottomHeight : CGFloat = (deviceModel == .iPhoneX) ? 34 : 0

class JXNumInputTextView: JXView {

    var delegate : JXNumInputTextViewDelegate?
    var sendBlock : ClickBlock?
    var cancelBlock : ClickBlock?
    
    //private let topBarHeight : CGFloat = 60
    var useTopBar : Bool = false {
        didSet{
            if useTopBar == true {
                self.addSubview(self.topBarView)
                
            }
        }
    }
    var limitWords : Int  =  0                     //限制字数，0默认不限制
    var limitLines : Int  =  4                     //限制行数，默认限制4行
   
    var text: String? {
        didSet {
            self.psdView.textField.text = text
        }
    }
    var topBarHeight: CGFloat = 60 {
        didSet {
            
        }
    }
    var font: UIFont = UIFont.systemFont(ofSize: 14){
        didSet {
            self.psdView.textField.font = font
        }
    }
    var textColor: UIColor = UIColor.darkGray{
        didSet {
            self.psdView.textField.textColor = textColor
        }
    }
    //MARK:public methods
    func show() {
        
        self.clearInfo()
        
        if self.useTopBar {
            self.frame = CGRect.init(x: 0, y: keyWindowHeight, width: keyWindowWidth, height: topBarHeight + inputViewTopBarHeight - inputViewTopMargin)
        } else {
            self.frame = CGRect.init(x: 0, y: keyWindowHeight, width: keyWindowWidth, height: topBarHeight)
        }
        
        let superView = self.bgWindow!
        
        superView.addSubview(self.tapControl)
        superView.addSubview(self)
        //superview.insertSubview(self.tapControl, belowSubview: self)
        self.psdView.textField.becomeFirstResponder()
    }
    func dismiss() {
        self.psdView.textField.resignFirstResponder()
    }
    //MARK: private properties
    private var contentView : UIView?
    private var keyboardRect = CGRect()
    private var animateDuration = 0.25
    private var isKeyboardShow = false
    
    
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
    private lazy var psdView: PasswordTextView = {
        
        let psdTextView = PasswordTextView(frame: CGRect())
        //psdTextView.textField.delegate = self
        psdTextView.backgroundColor = UIColor.white //要先设置颜色，再设置透明，不然不起作用，还有绘制的问题，待研究
        //contentView.addSubview(psdTextView)
        
        psdTextView.backgroundColor = UIColor.clear
        psdTextView.limit = 4
        psdTextView.bottomLineColor = JXSeparatorColor
        psdTextView.textColor = JXFfffffColor
        psdTextView.font = UIFont.systemFont(ofSize: 21)
        psdTextView.completionBlock = { (text,isFinish) -> () in
            
//            if isFinish {
//                self.closeStatus()
//                self.confirm(psd: text)
//            }
        }
        
        return psdTextView
    }()
    lazy var topBarView: NumInputTopView = {
        let top = NumInputTopView()
        top.cancelBlock = {
            if let block = self.cancelBlock {
                block(self, self.psdView.textField.text)
            }
            self.psdView.textField.text = ""
            self.psdView.textField.resignFirstResponder()
            self.dismiss()
        }
        top.confirmBlock = {
            if let block = self.sendBlock {
                block(self,self.psdView.textField.text)
            }
        }
        return top
    }()
    //MARK:private methods
    private func setTopBar() {
        self.contentView = self.psdView
        self.addSubview(self.contentView!)
    }
    private func setKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notify:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notify:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    @objc private func tapClick() {
        self.dismiss()
    }
    fileprivate func clearInfo() {
        self.tapControl.removeFromSuperview()
        self.removeFromSuperview()
    }
    //MARK:system methods
    init(frame: CGRect, completion: ClickBlock?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.groupTableViewBackground
        
        self.setTopBar()
        self.setKeyBoardObserver()
        self.sendBlock = completion
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.frame = CGRect(x: 0, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        if self.useTopBar == true {
            self.topBarView.frame = CGRect(x: 0, y: 0, width: frame.width, height: inputViewTopBarHeight)
            //self.contentView?.frame = CGRect(x: inputViewMargin, y: inputViewTopBarHeight, width: inputViewWidth, height: topBarHeight - inputViewTopMargin - inputViewBottomMargin)
            self.contentView?.frame = CGRect(x: (kScreenWidth - 176) / 2, y: inputViewTopBarHeight, width: 176, height: 60)
        } else {
            self.contentView?.frame = CGRect(x: inputViewMargin, y: inputViewTopMargin, width: inputViewWidth, height: topBarHeight - inputViewTopMargin - inputViewBottomMargin)
        }
        
    }
}
extension JXNumInputTextView {
    @objc func keyboardWillShow(notify:Notification) {
        
        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        self.animateDuration = animationDuration
        self.keyboardRect = rect
       
        UIView.animate(withDuration: animationDuration, animations: {
            if self.useTopBar {
                self.frame = CGRect(x: 0, y: keyWindowHeight - (self.topBarHeight + inputViewTopBarHeight - inputViewTopMargin) - self.keyboardRect.height, width: keyWindowWidth, height: self.topBarHeight + inputViewTopBarHeight - inputViewTopMargin)
            } else {
                self.frame = CGRect(x: 0, y: keyWindowHeight - self.topBarHeight - self.keyboardRect.height, width: keyWindowWidth, height: self.topBarHeight)
            }
            self.tapControl.alpha = 0.2
        }) { (finish) in
            //
        }
    }
    @objc func keyboardWillHide(notify:Notification) {
        print("notify = ","notify")
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        
        UIView.animate(withDuration: animationDuration, animations: {
            
            self.frame = CGRect.init(x: 0, y: keyWindowHeight, width: keyWindowWidth, height: self.topBarHeight)
            self.tapControl.alpha = 0
        }) { (finish) in
            if finish {
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
   
}
extension JXNumInputTextView : UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //限制字数不可以限制回车，删除键，所以要优先响应，然后再限制
        //删除键
        if text == "" {
            if self.useTopBar {
                self.topBarView.titleLabel.textColor = UIColor.rgbColor(from: 160, 160, 160)
            }
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
            return false
        }
        //限制输入字符数
        if limitWords > 0 {
            if let string = textView.text, string.count >= limitWords {
                textView.text = String(string.prefix(upTo: string.index(string.startIndex, offsetBy: limitWords)))
                //textView.text = string.substring(to: string.index(string.startIndex, offsetBy: 500))
                ViewManager.showNotice("字符个数不能大于\(limitWords)")
                return false
            } else {
                if self.useTopBar {
                    if textView.text.count == limitWords - 1{
                        self.topBarView.titleLabel.textColor = UIColor.rgbColor(from: 251, 74, 88)
                    } else {
                        self.topBarView.titleLabel.textColor = UIColor.rgbColor(from: 160, 160, 160)
                    }
                }
            }
        }
        return true
    }
}
class NumInputTopView: UIView {

    lazy var cancelButton: UIButton = {
        
        let button = UIButton()
        button.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        //button.center = CGPoint(x: 30, y: view.jxCenterY)
        //button.setTitle("×", for: .normal)
        button.tintColor = JXFfffffColor
        button.setImage(UIImage(named: "Close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.setTitleColor(JX333333Color, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(cnacelClick), for: .touchUpInside)

        return button
    }()
    lazy var confirmButton: UIButton = {
        let button1 = UIButton()
        button1.frame = CGRect(x: kScreenWidth - 80 - 24, y: 10, width: 80, height: 40)
        //button.center = CGPoint(x: 30, y: view.jxCenterY)
        button1.setTitle("忘记密码？", for: .normal)
        
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button1.setTitleColor(JXOrangeColor, for: .normal)
        button1.contentVerticalAlignment = .center
        button1.contentHorizontalAlignment = .right
        button1.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
       
        return button1
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 60)
        //label.center = view.center
        label.text = "输入资金密码"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = JXFfffffColor
        
        return label
    }()
    var cancelBlock : (()->())?
    var confirmBlock : (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(self.cancelButton)
        addSubview(self.confirmButton)
        addSubview(self.titleLabel)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        self.titleLabel.frame = CGRect(x: 15, y: 10, width: 100, height: 40)
        self.titleLabel.center = self.center
        self.confirmButton.frame = CGRect(x: kScreenWidth - 80 - 24, y: 10, width: 80, height: 40)
    }
    @objc func cnacelClick() {
        if let block = cancelBlock {
            block()
        }
    }
    @objc func confirmClick() {
        if let block = confirmBlock {
            block()
        }
    }
}

