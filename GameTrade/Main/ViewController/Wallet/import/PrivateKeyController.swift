//
//  PrivateKeyController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift
import JXFoundation

class PrivateKeyController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: JXPlaceHolderTextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var importButton: UIButton!
    
    @IBOutlet weak var contentSize_heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "导入钱包"
        self.textView.placeHolderText = "直接复制粘贴以太坊官方钱包keystore文件内容至输入框即可，或者通过生成的keystore内容的二维码扫描录入"
        
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 100, height: self.importButton.jxHeight)
        gradientLayer.cornerRadius = 22
        self.importButton.layer.insertSublayer(gradientLayer, at: 0)
        self.importButton.backgroundColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight
        self.contentSize_heightConstraint.constant = UIScreen.main.bounds.height - kNavStatusHeight
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    @IBAction func importAction(_ sender: Any) {
        
        guard let name = self.nameTextField.text, name.isEmpty == false else { return }
        guard let password = self.passwordTextField.text, password.isEmpty == false else { return }
        guard let privateKeyStr = self.textView.text, privateKeyStr.isEmpty == false else { return }
        guard let keyStore1 = try? EthereumKeystoreV3.init(privateKey: Data.init(hex: privateKeyStr), password: password),
            let keyStore = keyStore1 else {
                print("keyStore无效")
                return
        }
        do {
            try keyStore.regenerate(oldPassword: password, newPassword: password)
        } catch let error {
            print("原钱包密码错误")
            print(error)
            return
        }
        print("导入成功")
        
        guard let keystoreData = try? keyStore.serialize() else { return }
        guard let keystoreData1 = keystoreData else { return }
        let keystoreBase64Str = keystoreData1.base64EncodedString()
        
        let address = keyStore.addresses![0]
        //let privateKey = try! keyStore.UNSAFE_getPrivateKeyData(password: password, account: address).toHexString()
        
        let dict = ["name":name,"isDefault":false,"address":address.address,"keystore":keystoreBase64Str] as [String : Any]
        let _ = WalletDB.shareInstance.createTable(keys: Array(dict.keys))
        let isSuc = WalletDB.shareInstance.appendWallet(data: dict, key: address.address)
        if isSuc {
            print("添加成功")
            if let block = backBlock {
                block()
            }
            let _ = WalletManager.manager.switchWallet(dict: dict)
            self.navigationController?.popViewController(animated: true)
        } else {
            print("钱包已存在")
        }
    }

}
extension PrivateKeyController : UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate{
    @objc func keyboardWillShow(notify:Notification) {
        
        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        
        self.scrollView.setContentOffset(CGPoint(x: 0, y: self.contentSize_heightConstraint.constant - rect.size.height), animated: true)
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
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            self.view.endEditing(true)
        }
    }
}
