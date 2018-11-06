//
//  SettingViewController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

    var vm = LoginVM()
    
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "系统设置"
        
        self.noticeLabel.textColor = JXTextColor
        
        self.versionLabel.text = kVersion
        self.versionLabel.textColor = JXTextColor
        
        self.logoutButton.setTitleColor(JXTextColor, for: .normal)
        self.logoutButton.backgroundColor = JXOrangeColor
        self.logoutButton.layer.cornerRadius = 2
        self.logoutButton.layer.shadowOpacity = 1
        self.logoutButton.layer.shadowRadius = 10
        self.logoutButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.logoutButton.layer.shadowColor = JX10101aShadowColor.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logout(_ sender: Any) {
        self.vm.logout { (data, msg, isSuccess) in
            if isSuccess {
                self.navigationController?.popToRootViewController(animated: false)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: false)
            }else {
                ViewManager.showNotice(msg)
            }
        }
    }
    
}
