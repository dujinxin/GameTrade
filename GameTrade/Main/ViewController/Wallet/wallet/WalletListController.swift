//
//  WalletListController.swift
//  EthWallet
//
//  Created by 杜进新 on 2018/6/20.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class WalletListController: UITableViewController {
    
    var dataArray = Array<Any>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
//        DispatchQueue.global().async {
//
//        }
        let date1 = Date()
        dataArray = WalletDB.shareInstance.selectData()!
        let date2 = Date()
        
        print(date1)
        print(date2)
        print(dataArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
        case "createWallet":
            let vc = segue.destination as! CreateWalletController
            vc.backBlock = { ()->() in
                self.dataArray.removeAll()
                self.dataArray = WalletDB.shareInstance.selectData()!
                self.tableView.reloadData()
            }
        case "importWallet":
            let vc = segue.destination as! ImportWalletController
            vc.backBlock = { ()->() in
                self.dataArray.removeAll()
                self.dataArray = WalletDB.shareInstance.selectData()!
                self.tableView.reloadData()
            }
        case "walletDetail":
            let vc = segue.destination as! WalletDetailController
            let dict = sender as! Dictionary<String,Any>
            vc.dict = dict
        default:
            print("11")
        }
        
    }
    @IBAction func walletAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "创建钱包", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "createWallet", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "导入钱包", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "importWallet", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)

        let dict = dataArray[indexPath.row] as! Dictionary<String,Any>
        
        cell.textLabel?.text = dict["name"] as? String

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dict = dataArray[indexPath.row]
        self.performSegue(withIdentifier: "walletDetail", sender: dict)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}
