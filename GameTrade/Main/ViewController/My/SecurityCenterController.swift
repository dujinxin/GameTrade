//
//  SecurityCenterController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/19.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class SecurityCenterController: JXTableViewController {

    let vm = MyVM()
    
    var mobile : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安全中心"

        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        
        self.tableView?.separatorStyle = .singleLine
        self.tableView?.separatorColor = JXSeparatorColor
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = JXTextColor
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        if indexPath.row == 0 {
            cell.textLabel?.text = "登录密码"
        } else {
            cell.textLabel?.text = "资金密码"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "modifyLogPsw") as! ModifyLogPswController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }  else {
            self.showMBProgressHUD()
            self.vm.sendMobileCode(type: 2) { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                
                let storyboard = UIStoryboard(name: "My", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "modifyTradePsw") as! ModifyTradePswController
                vc.hidesBottomBarWhenPushed = true
                vc.mobile = self.mobile
                vc.type = 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }

}
