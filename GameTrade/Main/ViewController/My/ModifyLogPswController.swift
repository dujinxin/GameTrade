//
//  ModifyLogPswController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ModifyLogPswController: BaseViewController {

    @IBOutlet weak var loginTitleLabel: UILabel!
    @IBOutlet weak var loginLittleLabel: UILabel!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var vm = MyVM()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.loginTitleLabel.textColor = JXTextColor
        self.loginLittleLabel.textColor = JXText50Color
       
        
        self.codeTextField.attributedPlaceholder = NSAttributedString(string: "4位手机验证码", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "输入8-20位密码，不能全是数字或字母", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:JXPlaceHolerColor])
        
        self.codeTextField.textColor = JXTextColor
        self.passwordTextField.textColor = JXTextColor
        
        self.codeButton.setTitleColor(JXTextColor, for: .normal)
        self.codeButton.backgroundColor = JXOrangeColor
        
        self.codeButton.layer.cornerRadius = 2
        self.codeButton.layer.shadowOpacity = 1
        self.codeButton.layer.shadowRadius = 10
        self.codeButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.codeButton.layer.shadowColor = JX10101aShadowColor.cgColor
        
        
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
        
        self.confirmButton.setTitleColor(JXTextColor, for: .normal)
        self.confirmButton.backgroundColor = JXOrangeColor
        
        self.confirmButton.layer.cornerRadius = 2
        self.confirmButton.layer.shadowOpacity = 1
        self.confirmButton.layer.shadowRadius = 10
        self.confirmButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.confirmButton.layer.shadowColor = JX10101aShadowColor.cgColor
        
        
        self.showMBProgressHUD()
        self.vm.sendMobileCode(type: 1) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuc {
                CommonManager.countDown(timeOut: 60, process: { (currentTime) in
                    UIView.beginAnimations(nil, context: nil)
                    self.codeButton.setTitle(String(format: "%d", currentTime), for: .normal)
                    UIView.commitAnimations()
                    self.codeButton.isEnabled = false
                }) {
                    self.codeButton.setTitle("获取验证码", for: .normal)
                    self.codeButton.isEnabled = true
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func confirm(_ sender: Any) {
        guard String.validate(codeTextField.text, type: .code4, emptyMsg: "验证码未填写", formatMsg: "验证码填写错误") == true else { return }
        guard let password = self.passwordTextField.text, password.isEmpty == false else {
            ViewManager.showNotice("密码未填写")
            return
        }
        
        if self.validate(password) == false {
            ViewManager.showNotice("密码格式错误")
            return
        }
        
        self.showMBProgressHUD()
        
        self.vm.modifyLogPsd(code: codeTextField.text!, password: passwordTextField.text!) { (data, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                self.navigationController?.popToRootViewController(animated: false)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: false)
            }else{
                ViewManager.showNotice(msg)
            }
        }
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
    func validate(_ string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$")
        return predicate.evaluate(with: string)
    }
}
extension ModifyLogPswController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == codeTextField {
            self.passwordTextField.becomeFirstResponder()
            return false
        } else {
            textField.resignFirstResponder()
            return true
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == passwordTextField {
            if range.location > 19 {
                return false
            }
        } else if textField == codeTextField {
            if range.location > 3 {
                return false
            }
        }
        return true
    }
}
