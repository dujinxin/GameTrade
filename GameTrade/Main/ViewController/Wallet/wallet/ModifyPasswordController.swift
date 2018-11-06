//
//  ModifyPasswordController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/22.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift

class ModifyPasswordController: UITableViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    var dict = Dictionary<String,Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func confirm(_ sender: Any) {
        guard let oldPsd = self.oldPasswordTextField.text else { return }
        guard let newPsd = self.newPasswordTextField.text else { return }
        guard let confirmPsd = self.confirmPasswordTextField.text else { return }
        
        if !(!oldPsd.isEmpty && !newPsd.isEmpty && !confirmPsd.isEmpty){
            print("密码不能为空")
            return
        }
        if newPsd == oldPsd {
            print("请设置一个与原密码不一样的新密码")
            return
        }
        if newPsd != confirmPsd {
            print("两次密码不一致")
            return
        }
        guard
            let keystoreBase64Str = self.dict["keystore"] as? String,
            let keystoreData = Data.init(base64Encoded: keystoreBase64Str),
            let keystoreStr = String.init(data: keystoreData, encoding: .utf8) else {
                return
        }
        guard let keyStore = EthereumKeystoreV3(keystoreStr) else {
            print("keyStore无效")
            return
        }
        
        do {
            try keyStore.regenerate(oldPassword: oldPsd, newPassword: newPsd)
        } catch let error {
            print("原钱包密码错误")
            print(error)
            return
        }
        print("修改成功")
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
