//
//  JXSecretTextView.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/26.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class JXSecretTextView: UIView {
    
    var passwordBlock : ((_ text: String)->())?
    var completionBlock : ((_ text: String, _ isFinish: Bool)->())?
    var limit : Int = 6
    var text : String = ""
    var textColor : UIColor = .darkText
    var font : UIFont = UIFont.systemFont(ofSize: 18)
    
    
    lazy var textField: UITextField = {
        let field = UITextField(frame: self.bounds)
        field.isHidden = true
        field.keyboardType = .numberPad
        field.addTarget(self, action: #selector(textChange), for: .editingChanged)
        field.delegate = self
        return field
    }()
    
    @objc func textChange(textField: UITextField) {
        guard let txt = self.textField.text else {
            return
        }
        self.textChangeHandle(txt)
    }
    func clearText() {
        text = ""
        self.textField.text = ""
        self.setNeedsDisplay()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textField.becomeFirstResponder()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        //画背景图
//        let field = UIImage(named: "password_in")
//        field?.draw(in: CGRect(origin: CGPoint(), size: self.frame.size))
//
//        //画圆点
//        var x : CGFloat, y = (frame.size.height - 16.0) / 2
//        let w : CGFloat = 16, h = w
//        let margin : CGFloat = 0, padding = (frame.size.width / 6 - 16) / 2
//        guard let count = self.textField.text?.count else { return }
//        for i in 0..<count {
//            x = margin + padding + CGFloat(i) * (w + 2 * padding)
//            let point = UIImage(named: "yuan")
//            point?.draw(in: CGRect(x: x, y: y, width: w, height: h))
//        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setSubView()
    }
    deinit {
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        //self.removeObserver(self, forKeyPath: "text")
    }
    func setSubView() {
        addSubview(self.textField)
        //self.textField.addObserver(self, forKeyPath: "text", options: [.old,.new], context: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(placeHolderTextChange(nofiy:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    /// 添加观察者，是为了确保用户设置初始值时placeHolder正常显示
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath,keyPath == "text",let change = change,let txt = change[.newKey] as? String else { return }
        print(txt)
    
        self.textChangeHandle(txt)
    }
    func textChangeHandle(_ text: String) {
        self.text = text
        
        if text.count > limit {
            textField.resignFirstResponder()
        }
        print(self.text)
        if let block = passwordBlock {
            block(self.text)
        }
        self.setNeedsDisplay()
        if let block = completionBlock {
            block(self.text, text.count == limit)
        }
    }
}
extension JXSecretTextView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location >= self.limit {
            return false
        }
        return true
    }
}
