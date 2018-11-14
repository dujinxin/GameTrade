//
//  JXKeyboardToolBar.swift
//  FBSnapshotTestCase
//
//  Created by 杜进新 on 2018/11/10.
//

import UIKit

public enum JXKeyboardToolBarAction: Int {
    case up      =   0
    case down
    case close
}

private let keyWindowWidth : CGFloat = UIScreen.main.bounds.width
private let keyWindowHeight : CGFloat = UIScreen.main.bounds.height



public class JXKeyboardToolBar: UIView {
    
    public typealias KeyboardShowBlock = ((_ height: CGFloat, _ rect: CGRect)->())

    public var showBlock : KeyboardShowBlock?
 
    public var views: Array<Any> = [] {
        didSet {
            self.isUpDownShow = (views.count > 2)
        }
    }
    public var index: Int = 0
    public var keyBoardHeight: CGFloat = 0
    public var textViewFrame: CGRect = CGRect()
    public var text: String? {
        didSet {
            //self.textView.text = text
        }
    }
    public var topBarHeight: CGFloat = 49 {
        didSet {
            self.toolBar.frame = CGRect(x: toolEdgeInsets.left, y: toolEdgeInsets.top, width: kScreenWidth - toolEdgeInsets.left - toolEdgeInsets.right, height: topBarHeight - toolEdgeInsets.top - toolEdgeInsets.bottom)
        }
    }
    public var font: UIFont = UIFont.systemFont(ofSize: 14){
        didSet {
            //self.textView.font = font
        }
    }
    public var textColor: UIColor = UIColor.darkGray{
        didSet {
            //self.textView.textColor = textColor
        }
    }
    //MARK:public methods

    //MARK: private properties
    private var textView : UIView?
    private var keyboardRect = CGRect()
    private var animateDuration = 0.25
    private var isKeyboardShow = false
    private var isUpDownShow : Bool = false {
        didSet {
            if isUpDownShow {
                self.upItem?.title = ""
                self.downItem?.title = ""
                self.upItem?.isEnabled = false
                self.downItem?.isEnabled = false
            } else {
                self.upItem?.title = " ↑ "
                self.downItem?.title = " ↓ "
                self.upItem?.isEnabled = true
                self.downItem?.isEnabled = true
            }
        }
    }
    var upItem : UIBarButtonItem?
    var downItem : UIBarButtonItem?
    public var toolEdgeInsets : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet{
            self.toolBar.frame = CGRect(x: toolEdgeInsets.left, y: toolEdgeInsets.top, width: kScreenWidth - toolEdgeInsets.left - toolEdgeInsets.right, height: topBarHeight - toolEdgeInsets.top - toolEdgeInsets.bottom)
        }
    }
    
    lazy var toolBar: UIToolbar = {
        let tool = UIToolbar(frame: CGRect())
        //tool.backgroundColor = UIColor.red
        
        tool.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        var items = [UIBarButtonItem]()
        var title = ""
        for i in 0..<3 {

            let item = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: #selector(change(_:)))
            item.isEnabled = true
            item.tag = i
            if i == 0 {
                item.title = " ↑ "
                self.upItem = item
            } else if i == 1 {
                item.title = " ↓ "
                self.downItem = item
            } else {
                item.title = "关闭"
            }
            items.append(item)
        }
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        items.insert(item, at: 2)
        tool.items = items
        //tool.items = [UIBarButtonItem(title: "↑", style: UIBarButtonItem.Style.plain, target: self, action: #selector(up)),UIBarButtonItem(title: "↓", style: UIBarButtonItem.Style.plain, target: self, action: #selector(down)),UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),UIBarButtonItem(title: "关闭", style: UIBarButtonItem.Style.plain, target: self, action: #selector(close)),]
        return tool
    }()
 
    //MARK:private methods
    
    private func setKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notify:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notify:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    @objc private func change(_ item: UIBarButtonItem) {
        
        if self.views.count < 2 {
            return
        }
        if item.tag == 0 {
            let v = self.views[self.index - 1]
            if v is UITextField, let textField = v as? UITextField, textField.isFirstResponder == false {
                textField.becomeFirstResponder()
            } else if v is UITextView, let textView = v as? UITextView, textView.isFirstResponder == false {
                textView.becomeFirstResponder()
            } else {
                print("shit!!!")
            }
        } else if item.tag == 1 {
            let v = self.views[self.index + 1]
            if v is UITextField, let textField = v as? UITextField, textField.isFirstResponder == false {
                textField.becomeFirstResponder()
            } else if v is UITextView, let textView = v as? UITextView, textView.isFirstResponder == false {
                textView.becomeFirstResponder()
            } else {
                print("shit!!!")
            }
        } else if item.tag == 2{
            let v = self.views[self.index]
            if v is UITextField, let textField = v as? UITextField, textField.isFirstResponder == true {
                textField.resignFirstResponder()
            } else if v is UITextView, let textView = v as? UITextView, textView.isFirstResponder == true {
                textView.resignFirstResponder()
            } else {
                print("shit!!!")
            }
        }
        
    }
    private func updateState(_ index: Int) {
        print("current index = ", index)
        if self.views.count < 2 {
            return
        }
        if index == 0 {
            self.upItem?.isEnabled = false
            self.downItem?.isEnabled = true
        } else if index == self.views.count - 1 {
            self.downItem?.isEnabled = false
            self.upItem?.isEnabled = true
        } else {
            self.downItem?.isEnabled = true
            self.upItem?.isEnabled = true
        }
    }
    
    //MARK:system methods
    public init(frame: CGRect = CGRect(), views: Array<Any> = [], animationBlock: KeyboardShowBlock? = nil) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.groupTableViewBackground
        //UITextInput
        self.setKeyBoardObserver()
        self.showBlock = animationBlock
        self.addSubview(self.toolBar)
        self.views = views
        self.isUpDownShow = (self.views.count > 2)
        
        self.frame = CGRect.init(x: 0, y: keyWindowHeight, width: keyWindowWidth, height: topBarHeight)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.toolBar.frame = CGRect(x: toolEdgeInsets.left, y: toolEdgeInsets.top, width: kScreenWidth - toolEdgeInsets.left - toolEdgeInsets.right, height: topBarHeight - toolEdgeInsets.top - toolEdgeInsets.bottom)
    }
}
extension JXKeyboardToolBar {
    @objc func keyboardWillShow(notify:Notification) {
        print("notify = ","show")
        
        for i in 0..<self.views.count {
            let v = self.views[i]
            if v is UITextField, let textField = v as? UITextField, textField.isFirstResponder == true {
                self.index = i
                self.textViewFrame = textField.frame
            } else if v is UITextView, let textView = v as? UITextView, textView.isFirstResponder == true {
                self.index = i
                self.textViewFrame = textView.frame
            } else {
                print("shit!!!")
            }
        }
        
        self.updateState(self.index)
        
        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        self.animateDuration = animationDuration
        self.keyboardRect = rect
        
        
        if let block = self.showBlock {
            block(self.topBarHeight + self.keyboardRect.height, self.textViewFrame)
        }
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.frame = CGRect(x: 0, y: keyWindowHeight - self.topBarHeight - self.keyboardRect.height, width: keyWindowWidth, height: self.topBarHeight)
           
        }) { (finish) in
            //
        }
    }
    @objc func keyboardWillHide(notify:Notification) {
        print("notify = ","hide")
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.frame = CGRect.init(x: 0, y: keyWindowHeight, width: keyWindowWidth, height: self.topBarHeight)
        }) { (finish) in
            
        }
    }
    @objc func keyboardDidShow(notify:Notification) {
        self.isKeyboardShow = true
    }
    @objc func keyboardDidHide(notify:Notification) {
        self.isKeyboardShow = false
    }
    
}
