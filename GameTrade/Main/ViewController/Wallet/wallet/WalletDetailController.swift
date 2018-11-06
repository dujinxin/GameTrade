//
//  WalletDetailController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/21.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit
import web3swift
import BigInt


class WalletDetailController: UITableViewController {

    @IBOutlet weak var walletImageView: UIImageView!
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var walletNumberLabel: UILabel!
    @IBOutlet weak var walletNumberTypeLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var walletNameLabel1: UILabel!
    
    var dict = Dictionary<String,Any>()
    
    var vm : Web3VM?
    
    
    lazy var web3: web3? = {
        let w = Web3.new(URL(string: "http://192.168.0.129:8545")!)
        return w
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.walletNameLabel.text = dict["name"] as? String
        self.walletNameLabel1.text = dict["name"] as? String
      
        guard let address = dict["address"] as? String else { return }
        guard let ethereumAddress = EthereumAddress(address) else {return}
        guard let keystoreBase64Str = self.dict["keystore"] as? String else {return}
        self.vm = Web3VM(keystoreBase64Str: keystoreBase64Str)

        DispatchQueue.global().async {
            let balanceResult = self.vm?.web3.eth.getBalance(address: ethereumAddress)
            guard case .success(let balance)? = balanceResult else { return }
            print("balance = ",balance)
            DispatchQueue.main.async {
                let ether = EthUnit.weiToEther(wei: EthUnit.Wei(balance))
                
                self.walletNumberLabel.text = "\(ether)"
                print(ether)

            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        
        switch segue.identifier {
        case "exportKeystore":
            guard let str = sender as? String else {
                return
            }
            let vc = segue.destination as! ExportKSViewController
            vc.keystoreStr = str
            vc.backBlock = { ()->() in
        
            }
        case "exportPrivateKey":
            //let vc = segue.destination as! ExportPKViewController
            print("none")
        case "modifyPassword":
            let vc = segue.destination as! ModifyPasswordController
            vc.dict = self.dict
        default:
            print("none")
        }
    }
    @IBAction func scan(_ sender: Any) {
    }
    @IBAction func deleteWallet(_ sender: Any) {
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {

            if indexPath.row == 1 {
                self.performSegue(withIdentifier: "modifyPassword", sender: nil)
            } else if indexPath.row > 1 {
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
                        self.export(password:text, indexPath: indexPath)
                    }
                }))
                alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                }))
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    func export(password:String,indexPath:IndexPath) {

        do {
            try self.vm?.keystore?.regenerate(oldPassword: password, newPassword: password)
        } catch let error {
            print("原钱包密码错误")
            print(error)
            return
        }
        //        let jsonStr = String.init(data: keyStore.serialize(), encoding:.utf8)
        //        let jsonDict = JSONSerialization.jsonObject(with: keyStore.serialize(), options: [])

        if indexPath.row == 2 { //导出keystore
            guard let keystoreBase64Str = self.dict["keystore"] as? String else {return}
            self.performSegue(withIdentifier: "exportKeystore", sender: String.convertBase64Str(keystoreBase64Str))
        } else if indexPath.row == 3{ //导出私钥
            let address = self.vm?.keystore?.addresses![0]
            let privateKey = try! self.vm?.keystore?.UNSAFE_getPrivateKeyData(password: password, account: address!).toHexString()
            
            print("私钥 = ",privateKey)
            //self.performSegue(withIdentifier: "exportPrivateKey", sender: nil)
        }
    }

}
