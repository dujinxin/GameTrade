//
//  ModifyTradePswController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/26.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ModifyTradePswController: BaseViewController {

    @IBOutlet weak var noticeLargeLabel: UILabel!{
        didSet{
            noticeLargeLabel.textColor = JXLargeTitleColor
        }
    }
    @IBOutlet weak var noticeEnglishLabel: UILabel!{
        didSet{
            noticeEnglishLabel.textColor = JXLittleTitleColor
        }
    }
    @IBOutlet weak var noticeLabel: UILabel!{
        didSet{
            noticeLabel.textColor = JXMainTextColor
        }
    }
    @IBOutlet weak var fetchButton: UIButton!{
        didSet{
            fetchButton.setTitleColor(JXMainTextColor, for: .normal)
        }
    }
    @IBOutlet weak var psdView: PasswordTextView!{
        didSet{
            
            psdView.limit = 4
            psdView.bottomLineColor = JXSeparatorColor
            psdView.textColor = JXMainTextColor
            psdView.font = UIFont.systemFont(ofSize: 21)
            psdView.backgroundColor = UIColor.clear
            psdView.completionBlock = {(psd, isFinish) in
                if isFinish {
                    self.submit(psd)
                }
            }
        }
    }
    
    let vm = MyVM()
    
    var type = 0  //0修改资金密码 第一步 输入验证码 1修改资金密码 第二步 设置密码 2资金密码初始化 第一步 3资金密码初始化 第二步 确认
    var code = "" //修改资金密码，设置新密码，需要把校验成功后的验证码。type = 1时使用
    var psd : String = "" //资金密码初始化，需要把第一次的密码带入到第二次校验。type = 3时使用
    
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
        } else if type == 3 {
            self.noticeLargeLabel.text = "设置资金密码"
            self.noticeEnglishLabel.text = "Set fund password"
            self.noticeLabel.text = "重复四位数字新密码"
        }  else {
            self.noticeLargeLabel.text = "修改资金密码"
            self.noticeEnglishLabel.text = "Change fund password"
            self.noticeLabel.text = "我们已发送验证码到你的\(UserManager.manager.userEntity.user.mobile ?? "注册手机号上")"
            
            self.vm.sendMobileCode(type: 2) { (_, msg, isSuc) in
                self.hideMBProgressHUD()

                CommonManager.countDown(timeOut: 60, process: { (currentTime) in
                    UIView.beginAnimations(nil, context: nil)
                    self.fetchButton.setTitleColor(JXMainTextColor, for: .normal)
                    self.fetchButton.setTitle(String(format: "%d秒后重发", currentTime), for: .normal)
                    UIView.commitAnimations()
                    self.fetchButton.isEnabled = false
                }) {
                    self.fetchButton.setTitle("重发验证码", for: .normal)
                    self.fetchButton.setTitleColor(JXMainColor, for: .normal)
                    self.fetchButton.isEnabled = true
                }
            }
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if let controllers = self.navigationController?.viewControllers {
            if controllers.count > 1 {
                print(controllers)
                if self.type == 1 {
                    self.navigationController?.viewControllers.remove(at: controllers.count - 2)
                } else if self.type == 3 {
                    self.navigationController?.viewControllers.remove(at: controllers.count - 2)
                }
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
                self.fetchButton.setTitleColor(JXMainTextColor, for: .normal)
                self.fetchButton.setTitle(String(format: "%d秒后重发", currentTime), for: .normal)
                UIView.commitAnimations()
                self.fetchButton.isEnabled = false
            }) {
                self.fetchButton.setTitle("重发验证码", for: .normal)
                self.fetchButton.setTitleColor(JXMainColor, for: .normal)
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
        } else if self.type == 2 {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "modifyTradePsw") as! ModifyTradePswController
            vc.hidesBottomBarWhenPushed = true
            vc.type = 3
            vc.psd = psd
            self.navigationController?.pushViewController(vc, animated: true)
        } else if self.type == 3 {
            if self.psd != psd {
                self.psdView.clearText()
                ViewManager.showNotice("两次输入密码不一致，请重新输入！")
                return
            }
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
