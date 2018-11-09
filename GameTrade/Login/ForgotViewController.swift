//
//  ForgotViewController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ForgotViewController: BaseViewController {
    
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var loginLittleLabel: UILabel!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fetchButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var lookButton: UIButton!
    
    @IBOutlet weak var topConstraints: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    
    var vm = LoginVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            self.mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavStatusHeight, 0, 0, 0)
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.loginTitleLabel.textColor = JXTextColor
        self.loginLittleLabel.textColor = JXText50Color
        self.loginButton.backgroundColor = JXOrangeColor
        self.loginButton.setTitleColor(JXTextColor, for: .normal)
        self.loginButton.layer.cornerRadius = 3
      
        
        self.lookButton.backgroundColor = JXFfffffColor
        self.fetchButton.setTitleColor(JXTextColor, for: .normal)
        self.fetchButton.backgroundColor = JXOrangeColor
        
        self.userTextField.attributedPlaceholder = NSAttributedString(string: "手机号码", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        self.imageTextField.attributedPlaceholder = NSAttributedString(string: "图片验证码", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        self.codeTextField.attributedPlaceholder = NSAttributedString(string: "4位手机验证码", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "输入8-20位密码，不能全是数字或字母", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        
        self.userTextField.textColor = JXTextColor
        self.imageTextField.textColor = JXTextColor
        self.codeTextField.textColor = JXTextColor
        self.passwordTextField.textColor = JXTextColor
        
        self.passwordTextField.rightViewMode = .always
        self.passwordTextField.rightView = {() -> UIView in
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.setImage(UIImage(named: "icon_eye closed"), for: .normal)
            button.setImage(UIImage(named: "icon_eye open"), for: .selected)
            button.addTarget(self, action: #selector(switchPsd), for: .touchUpInside)
            button.isSelected = false
            button.tag = 1
            return button
        }()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        
        let url = URL.init(string: String(format: "%@%@?deviceId=%@&method=resetPwd&random=%d", kBaseUrl,ApiString.getImageCode.rawValue,UIDevice.current.uuid,arc4random_uniform(100000)))
        
        self.lookButton.sd_setImage(with: url, for: .normal, completed: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if let controllers = self.navigationController?.viewControllers {
            if controllers.count > 1 {
                self.navigationController?.viewControllers.remove(at: 0)
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func changePasswordText(_ sender: UIButton) {
        
        let url = URL.init(string: String(format: "%@%@?deviceId=%@&method=resetPwd&random=%d", kBaseUrl,ApiString.getImageCode.rawValue,UIDevice.current.uuid,arc4random_uniform(100000)))
        lookButton.sd_setImage(with: url, for: .normal, completed: nil)
        
    }
    @objc func switchPsd(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            self.passwordTextField.isSecureTextEntry = false
        }else{
            self.passwordTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func fetchCode(_ sender: UIButton) {
        guard String.validate(userTextField.text, type: .phone, emptyMsg: "手机号未填写", formatMsg: "手机号填写错误") == true else { return }
        guard String.validate(imageTextField.text, type: .none, emptyMsg: "图形验证码未填写", formatMsg: "") == true else { return }
        guard let imageCode = imageTextField.text,imageCode.isEmpty == false else {
            ViewManager.showNotice("图片验证码不能为空")
            return
        }
        self.showMBProgressHUD()
        self.vm.sendMobileCode(mobile: userTextField.text!, method: "resetPwd", validateCode: imageTextField.text!) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuc {
                CommonManager.countDown(timeOut: 60, process: { (currentTime) in
                    UIView.beginAnimations(nil, context: nil)
                    self.fetchButton.setTitle(String(format: "%d", currentTime), for: .normal)
                    UIView.commitAnimations()
                    self.fetchButton.isEnabled = false
                }) {
                    self.fetchButton.setTitle("获取验证码", for: .normal)
                    self.fetchButton.isEnabled = true
                }
            }
        }
    }
    
    @IBAction func logAction(_ sender: Any) {
        
        guard String.validate(userTextField.text, type: .phone, emptyMsg: "手机号未填写", formatMsg: "手机号填写错误") == true else { return }
        guard String.validate(codeTextField.text, type: .code4, emptyMsg: "短信验证码未填写", formatMsg: "短信验证码填写错误") == true else { return }
        //guard String.validate(passwordTextField.text, type: RegularExpression, emptyMsg: "密码未填写", formatMsg: "密码格式错误") == true else { return }
        guard let password = self.passwordTextField.text, password.isEmpty == false else {
            ViewManager.showNotice("密码未填写")
            return
        }
        
        if self.validate(password) == false {
            ViewManager.showNotice("密码格式错误")
            return
        }
        self.showMBProgressHUD()
        
        self.vm.resetPsd(mobile: userTextField.text!, password: passwordTextField.text ?? "", mobileCode: codeTextField.text!) { (_, msg, isSuccess) in
            self.hideMBProgressHUD()
            
            if isSuccess {
                ViewManager.showImageNotice(msg)
                UserManager.manager.removeAccound()
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                self.navigationController?.pushViewController(login, animated: true)
            } else {
                ViewManager.showNotice(msg)
            }
        }
        
    }
    //[a-zA-Z0-9]{8,20}+$                             8-20位数字或字母
    //^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$    8-20位数字加字母的组合
    func validate(_ string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$")
        return predicate.evaluate(with: string)
    }
}

extension ForgotViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            self.logAction(0)
            return textField.resignFirstResponder()
        } else if textField == imageTextField {
            codeTextField.becomeFirstResponder()
            return false
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == userTextField {
            if range.location > 10 {
                return false
            }
        } else if textField == codeTextField {
            if range.location > 3 {
                return false
            }
        }
        return true
    }
    @objc func textChange(notify:NSNotification) {
        guard let textField = notify.object as? UITextField else {
            return
        }
    }
    @objc func keyboardWillShow(notify:Notification) {
        
        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        
        //print(rect)//226
        UIView.animate(withDuration: animationDuration, animations: {
            self.mainScrollView.contentOffset = CGPoint(x: 0, y: 160)
            
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
            self.mainScrollView.contentOffset = CGPoint(x: 0, y: 0)
        }) { (finish) in
            
        }
    }
}
