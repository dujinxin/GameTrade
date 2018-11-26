//
//  LoginViewController.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/6/22.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit
//import JXFoundation

class LoginViewController: BaseViewController {

    @IBOutlet weak var loginTitleLabel: UILabel!{
        didSet{
            loginTitleLabel.textColor = JXTextColor
        }
    }
    @IBOutlet weak var loginLittleLabel: UILabel!{
        didSet{
            loginLittleLabel.textColor = JXText50Color
        }
    }
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentSize_heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!{
        didSet{
            contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        }
    }
    @IBOutlet weak var userTextField: UITextField!{
        didSet{
            userTextField.textColor = JXTextColor
            userTextField.attributedPlaceholder = NSAttributedString(string: "手机号码", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:JXPlaceHolerColor])
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            passwordTextField.attributedPlaceholder = NSAttributedString(string: "密码", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:JXPlaceHolerColor])
            passwordTextField.textColor = JXTextColor
            passwordTextField.rightViewMode = .always
            passwordTextField.rightView = {() -> UIView in
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                button.setImage(UIImage(named: "icon_eye closed"), for: .normal)
                button.setImage(UIImage(named: "icon_eye open"), for: .selected)
                button.addTarget(self, action: #selector(switchPsd), for: .touchUpInside)
                button.isSelected = false
                button.tag = 1
                return button
            }()
        }
    }
    
    
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet{
            loginButton.setTitleColor(JXTextColor, for: .normal)
            loginButton.backgroundColor = JXOrangeColor
            
            loginButton.layer.cornerRadius = 2
            loginButton.layer.shadowOpacity = 1
            loginButton.layer.shadowRadius = 10
            loginButton.layer.shadowOffset = CGSize(width: 0, height: 10)
            loginButton.layer.shadowColor = JX10101aShadowColor.cgColor
        }
    }
    @IBOutlet weak var forgotButton: UIButton!{
        didSet{
            forgotButton.setTitleColor(JXOrangeColor, for: .normal)
        }
    }
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.setTitleColor(JXOrangeColor, for: .normal)
        }
    }
    
    @IBOutlet weak var tonConstraints: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [userTextField,passwordTextField])
        k.showBlock = { (height, rect) in
            print(height,rect)
        }
        k.tintColor = JXTextColor
        k.toolBar.barTintColor = JXBackColor
        k.backgroundColor = JXBackColor
        k.textFieldDelegate = self
        return k
    }()
    
    var vm = LoginVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.updateButtonStatus()
        
        self.view.addSubview(self.keyboard)
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
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.contentSize_heightConstraint.constant = kScreenHeight
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

    @objc func switchPsd(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            self.passwordTextField.isSecureTextEntry = false
        }else{
            self.passwordTextField.isSecureTextEntry = true
        }
    }
    @IBAction func logAction(_ sender: Any) {
        
//        self.dismiss(animated: true, completion: {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: true)
//        })
//
//        return
        
        guard String.validate(userTextField.text, type: .phone, emptyMsg: "手机号未填写", formatMsg: "手机号填写错误") == true else { return }
        guard let password = self.passwordTextField.text, password.isEmpty == false else {
            ViewManager.showNotice("密码未填写")
            return
        }
        
//        if self.validate(password) == false {
//            ViewManager.showNotice("密码格式错误")
//            return
//        }

        self.showMBProgressHUD()
        
        self.vm.login(userName: userTextField.text!, password: passwordTextField.text!) { (data, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: true)
                })
            }else{
                ViewManager.showNotice(msg)
            }
        }
    }
    @IBAction func forgotPassword(_ sender: Any) {
    }
    @IBAction func goRegister(_ sender: Any) {
    }
    func validate(_ string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$")
        return predicate.evaluate(with: string)
    }
}
//MARK: 通过keyboardManager来管理之后,代理方法失效，需使用keyboardManager提供的代理方法
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == userTextField {
//            self.mainScrollView.contentOffset = CGPoint(x: 0, y: -60)
//        } else if textField == codeImageTextField{
//            self.mainScrollView.contentOffset = CGPoint(x: 0, y: -60 * 2)
//        } else if textField == codeWordTextField{
//            self.mainScrollView.contentOffset = CGPoint(x: 0, y: -60 * 2)
//        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == userTextField {
            if range.location > 10 {
                //let s = textField.text! as NSString
                //let str = s.substring(to: 10)
                //textField.text = str
                //ViewManager.showNotice(notice: "字符个数为11位")
                return false
            }
        }
        return true
    }
    @objc func textChange(notify: NSNotification) {
        
        if notify.object is UITextField {
            self.updateButtonStatus()
        }
    }
    func updateButtonStatus() {
        //登录按钮
        if
            let name = self.userTextField.text, name.isEmpty == false,
            let password = self.passwordTextField.text, password.isEmpty == false {
            
            self.loginButton.isEnabled = true
            self.loginButton.backgroundColor = JXOrangeColor
            self.loginButton.setTitleColor(JXTextColor, for: .normal)
            
        } else {
            
            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = UIColor.rgbColor(rgbValue: 0x9b9b9b)
            self.loginButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xb5b5b5), for: .normal)
            
        }
    }
    @objc func keyboardWillShow(notify:Notification) {

        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
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
            let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.mainScrollView.contentOffset = CGPoint(x: 0, y: 0)
        }) { (finish) in
            
        }
    }
}
extension LoginViewController: JXKeyboardTextFieldDelegate{
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == userTextField {
            if range.location > 10 {
                //let s = textField.text! as NSString
                //let str = s.substring(to: 10)
                //textField.text = str
                //ViewManager.showNotice(notice: "字符个数为11位")
                return false
            }
        } else if textField == passwordTextField {
            if range.location > 19 {
                return false
            }
        }
        return true
    }
}
