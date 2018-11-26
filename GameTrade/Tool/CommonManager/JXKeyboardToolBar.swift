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

protocol JXKeyboardTextFieldDelegate: AnyObject {
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}
protocol JXKeyboardTextViewDelegate: AnyObject {
    func keyboardTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
}

class JXKeyboardToolBar: UIView {
    
    public typealias KeyboardShowBlock = ((_ height: CGFloat, _ rect: CGRect)->())
    public typealias KeyboardCloseBlock = (()->())
    
    public var showBlock: KeyboardShowBlock?
    public var closeBlock: KeyboardCloseBlock?
    public weak var textFieldDelegate: JXKeyboardTextFieldDelegate?
    public weak var textViewDelegate: JXKeyboardTextViewDelegate?
    public var views: Array<UIView> = [] {
        didSet {
            if views.count > 1 {
                self.updown(true)
            } else {
                self.updown(false)
            }
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
    public override var tintColor: UIColor! {
        didSet{
            self.toolBar.tintColor = tintColor
        }
    }
    //MARK:public methods
    
    //MARK: private properties
    private var textView : UIView?
    private var keyboardRect = CGRect()
    private var animateDuration = 0.25
    private var isKeyboardShow = false
    private var isUpDownShow : Bool = false
    
    var upItem : UIBarButtonItem?
    var downItem : UIBarButtonItem?
    var closeItem : UIBarButtonItem?
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
            
            let item = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: self, action: #selector(changeResponder(_:)))
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
                self.closeItem = item
            }
            items.append(item)
        }
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        items.insert(item, at: 2)
        tool.items = items
        //tool.items = [UIBarButtonItem(title: "↑", style: UIBarButtonItem.Style.plain, target: self, action: #selector(up)),UIBarButtonItem(title: "↓", style: UIBarButtonItem.Style.plain, target: self, action: #selector(down)),UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),UIBarButtonItem(title: "关闭", style: UIBarButtonItem.Style.plain, target: self, action: #selector(close)),]
        return tool
    }()
    
    //MARK:system methods
    public init(frame: CGRect = CGRect(), views: Array<UIView> = []) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.groupTableViewBackground
        self.setKeyBoardObserver()
        self.addSubview(self.toolBar)
        self.views = views
        if views.count > 1 {
            self.updown(true)
        } else {
            self.updown(false)
        }
        self.setupDelegate()
        
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
    //MARK:private methods
    
    private func setKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notify:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notify:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    private func setupDelegate() {
        self.views.forEach { (v) in
            if v is UITextField, let textField = v as? UITextField{
                textField.delegate = self
            } else if v is UITextView, let textView = v as? UITextView{
                textView.delegate = self
            }
        }
    }
    @objc private func changeResponder(_ item: UIBarButtonItem) {
        if item.tag == 2 {
            if self.views.isEmpty {
                return
            }
            let v = self.views[self.index]
            if v is UITextField, let textField = v as? UITextField, textField.isFirstResponder == true {
                textField.resignFirstResponder()
            } else if v is UITextView, let textView = v as? UITextView, textView.isFirstResponder == true {
                textView.resignFirstResponder()
            } else {
                print("shit!!!")
            }
            if let block = self.closeBlock {
                block()
            }
        } else {
            if isUpDownShow == false {
                return
            }
            if item.tag == 0 {
                self.index -= 1
                let v = self.views[self.index]
                if v is UITextField, let textField = v as? UITextField, textField.isFirstResponder == false {
                    self.textViewFrame = textField.frame
                    textField.becomeFirstResponder()
                } else if v is UITextView, let textView = v as? UITextView, textView.isFirstResponder == false {
                    self.textViewFrame = textView.frame
                    textView.becomeFirstResponder()
                } else {
                    print("shit!!!")
                }
            } else if item.tag == 1 {
                self.index += 1
                let v = self.views[self.index]
                if v is UITextField, let textField = v as? UITextField, textField.isFirstResponder == false {
                    self.textViewFrame = textField.frame
                    textField.becomeFirstResponder()
                } else if v is UITextView, let textView = v as? UITextView, textView.isFirstResponder == false {
                    self.textViewFrame = textView.frame
                    textView.becomeFirstResponder()
                } else {
                    print("shit!!!")
                }
            }
        }
        
    }
    private func updown(_ isShow: Bool) {
        self.isUpDownShow = isShow
        if isShow {
            self.upItem?.title = " ↑ "
            self.downItem?.title = " ↓ "
            self.upItem?.isEnabled = true
            self.downItem?.isEnabled = true
        } else {
            self.upItem?.title = ""
            self.downItem?.title = ""
            self.upItem?.isEnabled = false
            self.downItem?.isEnabled = false
        }
    }
    private func updateItemState(forIndex: Int) {
        print("current index = ", index)
        if self.isUpDownShow == false {
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
    
    func handleState(view: UIView) {
       
        guard let currentIndex = self.views.index(of: view) else {
            return
        }
        self.index = currentIndex
        self.updateItemState(forIndex: self.index)
        if let block = self.showBlock {
            block(self.topBarHeight + self.keyboardRect.height, self.textViewFrame)
        }
    }
}
extension JXKeyboardToolBar {
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
        print(rect)
        
        if let block = self.showBlock {
            block(self.topBarHeight + self.keyboardRect.height, self.textViewFrame)
        }
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.frame = CGRect(x: 0, y: keyWindowHeight - self.topBarHeight - self.keyboardRect.height, width: keyWindowWidth, height: self.topBarHeight + self.keyboardRect.height)
            
        }) { (finish) in
            //
        }
    }
    @objc func keyboardWillHide(notify:Notification) {
        print("notify = ","hide")
        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        self.keyboardRect = rect
        UIView.animate(withDuration: animationDuration, animations: {
            self.frame = CGRect.init(x: 0, y: keyWindowHeight, width: keyWindowWidth, height: self.topBarHeight + self.keyboardRect.height)
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
extension JXKeyboardToolBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.handleState(view: textField)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let delegate = self.textFieldDelegate else { return true }
        return delegate.keyboardTextFieldShouldReturn(textField)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let delegate = self.textFieldDelegate else { return true }
        return delegate.keyboardTextField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
}
extension JXKeyboardToolBar: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.handleState(view: textView)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let delegate = self.textViewDelegate else { return true }
        return delegate.keyboardTextView(textView, shouldChangeTextIn: range, replacementText: text)
    }
}
