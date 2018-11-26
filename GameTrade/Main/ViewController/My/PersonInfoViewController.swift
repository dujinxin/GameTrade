//
//  PersonInfoViewController.swift
//  zpStar
//
//  Created by 杜进新 on 2018/5/10.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class PersonInfoViewController: JXTableViewController{
    
    var vm = LoginVM()
    var identifyVM = IdentifyVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的实名"
        
        self.tableView?.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableView.automaticDimension
        
        self.vm.identityInfo { (data, msg, isSuccess) in
            if isSuccess == false {
                ViewManager.showNotice(msg)
            }else {
                self.tableView?.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if !UserManager.manager.isLogin {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let loginVC = UINavigationController.init(rootViewController: login)
            self.navigationController?.present(loginVC, animated: false, completion: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! PersonCell
        if indexPath.row == 0 {
            cell.leftLabel.text = "手机号码"
            cell.rightLabel.text = self.vm.indentifyInfoEntity?.mobile
        } else if indexPath.row == 1 {
            cell.leftLabel.text = "姓名"
            cell.rightLabel.text = self.vm.indentifyInfoEntity?.name
        } else if indexPath.row == 2 {
            cell.leftLabel.text = "身份证号"
            cell.rightLabel.text = self.vm.indentifyInfoEntity?.idNumber
        } else {
            cell.leftLabel.text = "人脸识别"
            if self.vm.indentifyInfoEntity?.faceAuth == 1 {
                //cell.accessoryType = .checkmark
                cell.rightLabel.text = "已识别"//"✔已验证通过"
                cell.rightLabel.textColor = UIColor.rgbColor(rgbValue: 0x1e62cd)
            } else {
                //cell.accessoryType = .disclosureIndicator
                cell.rightLabel.text = "未识别"
                cell.rightLabel.textColor = UIColor.rgbColor(rgbValue: 0x3b4368)
            }
        }

        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 3 {
            if self.vm.indentifyInfoEntity?.faceAuth == 1 {
                
            } else {
                //self.identifyUserLiveness()
            }
        }
    }
}
