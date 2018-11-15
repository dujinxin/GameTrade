//
//  ModifyTradePswController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/26.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ModifyTradePswController: BaseViewController {

    @IBOutlet weak var noticeLargeLabel: UILabel!
    @IBOutlet weak var noticeEnglishLabel: UILabel!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var fetchButton: UIButton!
    @IBOutlet weak var psdView: PasswordTextView!
    
    let vm = MyVM()
    var mobile : String?
    
    var type = 0 //0修改资金密码输入验证码 1修改资金密码设置密码 2自己密码初始化
    var code = "" //修改资金密码，设置新密码，需要把校验成功后的验证码。type = 1时使用
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if type == 1 {
            self.noticeLargeLabel.text = "设置新密码"
            self.noticeEnglishLabel.text = "Set new password"
            self.noticeLabel.text = "设置四位数字新密码"
        } else if type == 2 {
            self.noticeLargeLabel.text = "设置资金密码"
            self.noticeEnglishLabel.text = "Set fund password"
            self.noticeLabel.text = "设置四位数字新密码"
        } else {
            self.noticeLargeLabel.text = "修改资金密码"
            self.noticeEnglishLabel.text = "Change fund password"
            self.noticeLabel.text = "我们已发送验证码到你的\(UserManager.manager.userEntity.user.mobile ?? "注册手机号上")"
            
            self.vm.sendMobileCode(type: 2) { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                
                CommonManager.countDown(timeOut: 60, process: { (currentTime) in
                    UIView.beginAnimations(nil, context: nil)
                    self.fetchButton.setTitleColor(JXTextColor, for: .normal)
                    self.fetchButton.setTitle(String(format: "%d秒后重发", currentTime), for: .normal)
                    UIView.commitAnimations()
                    self.fetchButton.isEnabled = false
                }) {
                    self.fetchButton.setTitle("重发验证码", for: .normal)
                    self.fetchButton.setTitleColor(JXOrangeColor, for: .normal)
                    self.fetchButton.isEnabled = true
                }
            }
        }
        
        
        self.fetchButton.setTitleColor(JXTextColor, for: .normal)
        //psdTextView.textField.delegate = self
        self.psdView.limit = 4
        self.psdView.bottomLineColor = JXSeparatorColor
        self.psdView.textColor = JXFfffffColor
        self.psdView.font = UIFont.systemFont(ofSize: 21)
        self.psdView.backgroundColor = UIColor.clear
        self.psdView.completionBlock = {(psd, isFinish) in
            print(psd)
            if isFinish {
                self.submit(psd)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if let controllers = self.navigationController?.viewControllers {
            if controllers.count > 1 && self.type == 1{
                self.navigationController?.viewControllers.remove(at: controllers.count - 2)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    @IBAction func fetchCode(_ sender: Any) {
        
        //不是修改密码获取验证码
        if type != 0 {
            return
        }
        
        self.showMBProgressHUD()
        self.vm.sendMobileCode(type: 2) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            
            CommonManager.countDown(timeOut: 60, process: { (currentTime) in
                UIView.beginAnimations(nil, context: nil)
                self.fetchButton.setTitleColor(JXTextColor, for: .normal)
                self.fetchButton.setTitle(String(format: "%d秒后重发", currentTime), for: .normal)
                UIView.commitAnimations()
                self.fetchButton.isEnabled = false
            }) {
                self.fetchButton.setTitle("重发验证码", for: .normal)
                self.fetchButton.setTitleColor(JXOrangeColor, for: .normal)
                self.fetchButton.isEnabled = true
            }
        }
    }
    func submit(_ psd: String) {
        if self.type == 0 {
            self.vm.modifyTradeValidatePsd(code: psd) { (_, msg, isSuc) in
                if isSuc && self.vm.validateResult != 0 {
                    let storyboard = UIStoryboard(name: "My", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "modifyTradePsw") as! ModifyTradePswController
                    vc.hidesBottomBarWhenPushed = true
                    vc.type = 1
                    vc.code = psd
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.psdView.clearText()
                    if msg.isEmpty == false {
                        ViewManager.showNotice(msg)
                    } else {
                        ViewManager.showNotice("验证码输入错误")
                    }
                }
            }
        } else if self.type == 1 {
            self.vm.modifyTradePsd(code: self.code, password: psd) { (_, msg, isSuc) in
                
                if isSuc {
                    ViewManager.showImageNotice("设置成功")
                    //self.navigationController?.popToRootViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    ViewManager.showNotice(msg)
                }
            }
        } else {
            self.vm.tradePsdInit(password: psd) { (_, msg, isSuc) in
                
                if isSuc {
                    ViewManager.showImageNotice(msg)
                    UserManager.manager.userEntity.user.safePwdInit = 1
                    self.navigationController?.popViewController(animated: true)
                } else {
                    ViewManager.showNotice(msg)
                }
            }
        }
    }
}
