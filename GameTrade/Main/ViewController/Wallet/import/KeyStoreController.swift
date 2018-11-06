//
//  KeyStoreController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift
import JXFoundation

class KeyStoreController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: JXPlaceHolderTextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var importButton: UIButton!
    
    @IBOutlet weak var contentSize_heightConstraint: NSLayoutConstraint!
    
    var backBlock : (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentSize_heightConstraint.constant = UIScreen.main.bounds.height - 44 - 88
        print(view.bounds.height)
        print(UIScreen.main.bounds.height)
        print(UIScreen.main.bounds.height - 44 - 64)
        self.textView.placeHolderText = "直接复制粘贴以太坊官方钱包keystore文件内容至输入框即可，或者通过生成的keystore内容的二维码扫描录入"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func selectAction(_ sender: UIButton) {
    }
    @IBAction func privacyAction(_ sender: Any) {
    }
    @IBAction func importAction(_ sender: Any) {
        
        guard let name = self.nameTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        guard let keystoreStr = self.textView.text else { return }
        
        guard let keyStore = EthereumKeystoreV3(keystoreStr) else {
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
        
        guard let keystoreData = keystoreStr.data(using: .utf8) else { return }
        
        let keystoreBase64Str = keystoreData.base64EncodedString(options: .lineLength64Characters)
        let address = keyStore.addresses![0]
        //let privateKey = try! keyStore.UNSAFE_getPrivateKeyData(password: password, account: address).toHexString()
        
        let dict = ["name":name,"isDefault":false,"address":address.address,"keystore":keystoreBase64Str] as [String : Any]
        let isSuc = WalletDB.shareInstance.appendWallet(data: dict, key: address.address)
        if isSuc {
            print("添加成功")
            if let block = backBlock {
                block()
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            print("钱包已存在")
        }
    }
}
extension KeyStoreController : UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate{
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
