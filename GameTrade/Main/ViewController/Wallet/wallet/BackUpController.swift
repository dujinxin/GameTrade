//
//  BackUpController.swift
//  Star
//
//  Created by 杜进新 on 2018/7/31.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import JXFoundation
import web3swift

class BackUpController: BaseViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textBackView: UIView!
    @IBOutlet weak var textView: JXPlaceHolderTextView!
    
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var infoLabelTopConstraint: NSLayoutConstraint!
    var vm : Web3VM?
    
    var isShow : Bool = false
    var isBackUp : Bool = true
    
    var callBack : (()->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "备份钱包"
        self.view.backgroundColor = UIColor.white
        
        self.textView.text = "******************************************"
        self.textView.textAlignment = .center
        self.textView.isEditable = false
        
        self.textBackView.layer.shadowColor =  UIColor.rgbColor(rgbValue: 0xe2e2e2).cgColor
        textBackView.layer.shadowOpacity = 0.5
        textBackView.layer.shadowRadius = 3
        textBackView.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        
        //颜色渐变
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.colors = [UIColor.rgbColor(from: 11, 69, 114).cgColor,UIColor.rgbColor(from:21,106,206).cgColor]
        gradientLayer.locations = [0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 100, height: self.unlockButton.jxHeight)
        gradientLayer.cornerRadius = 22
        self.unlockButton.layer.insertSublayer(gradientLayer, at: 0)
        self.unlockButton.backgroundColor = UIColor.clear
        
        
        
        if isBackUp {
            self.deleteButton.isHidden = true
        } else {
            self.deleteButton.isHidden = false
            deleteButton.layer.cornerRadius = 22
            deleteButton.setTitleColor(UIColor.rgbColor(rgbValue: 0x156ACE), for: .normal)
            deleteButton.layer.borderColor = UIColor.rgbColor(rgbValue: 0x156ACE).cgColor
            deleteButton.layer.borderWidth = 1
        }
        
        guard let dataArray = WalletDB.shareInstance.selectData() as? Array<Dictionary<String,String>> else{
            return
        }
        let dict = dataArray[0]
        //guard let address = dict["address"] else { return }
        //guard let ethereumAddress = EthereumAddress(address) else {return}
        guard let keystoreBase64Str = dict["keystore"] else {return}
        self.vm = Web3VM(keystoreBase64Str: keystoreBase64Str)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.topConstraint.constant = kNavStatusHeight
        self.bottomConstraint.constant = kBottomMaginHeight
        
        if isBackUp {
            self.infoLabelTopConstraint.constant = 25
        } else {
            self.infoLabelTopConstraint.constant = 25 * 2 + 44
        }
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    @IBAction func unlockCheck(_ sender: Any) {
        if isShow {
            guard
                let viewControllers = self.navigationController?.viewControllers,
                viewControllers.count > 2 else {
                return
            }
            let vc = viewControllers[1]
            self.navigationController?.popToViewController(vc, animated: true)
            return
        }
        let alertVC = UIAlertController(title: nil, message: "请输入密码", preferredStyle: .alert)
        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "password"
        })
        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            
            if
                let textField = alertVC.textFields?[0],
                let text = textField.text,
                text.isEmpty == false{
                
                self.validatePassword(text)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    @IBAction func deleteWallet(_ sender: Any) {
        let alertVC = UIAlertController(title: "请输入密码", message: "该操作不可撤销，确认删除？", preferredStyle: .alert)
        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "password"
        })
        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            
            
            
            if
                let textField = alertVC.textFields?[0],
                let text = textField.text,
                text.isEmpty == false{
                
                self.confirmDelete(password: text)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        self.present(alertVC, animated: true, completion: nil)
        
    }
    func confirmDelete(password: String) {
        do {
            try self.vm?.keystore?.regenerate(oldPassword: password, newPassword: password)
        } catch let error {
            print("原钱包密码错误")
            print(error)
            ViewManager.showNotice(error.localizedDescription)
            return
        }
        
        WalletManager.manager.removeAccound()
        let isSuc = WalletDB.shareInstance.deleteData()
        print("delete table ",isSuc)
        print("wallet isExist ",WalletManager.manager.isWalletExist)
        print(WalletManager.manager.walletEntity.address,WalletManager.manager.walletEntity.keystore,WalletManager.manager.walletEntity.name,WalletManager.manager.walletEntity.isDefault)
        if let block = callBack {
            block()
        }
        self.navigationController?.popViewController(animated: true)
    }
    func validatePassword(_ password: String) {
        do {
            try self.vm?.keystore?.regenerate(oldPassword: password, newPassword: password)
        } catch let error {
            print("原钱包密码错误")
            print(error)
            ViewManager.showNotice(error.localizedDescription)
            return
        }
        let address = self.vm?.keystore?.addresses![0]
        let privateKey = try! self.vm?.keystore?.UNSAFE_getPrivateKeyData(password: password, account: address!).toHexString()
        
        print("私钥 = ",privateKey ?? "")
        self.textView.text = privateKey
        self.unlockButton.setTitle("完成", for: .normal)
        isShow = true
    }
}
