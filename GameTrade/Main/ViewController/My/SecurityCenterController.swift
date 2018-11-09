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
    
    var noticeView : JXSelectView?
    
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
            self.showNoticeView1()
        }
    }

    //MARK: selectView1
    func showNoticeView1() {
        let width : CGFloat = kScreenWidth - 40 * 2
        let height : CGFloat = 300
        
        self.noticeView = JXSelectView(frame: CGRect(x: 0, y: 0, width: width, height: height), style: .custom)
        self.noticeView?.position = .middle
        self.noticeView?.customView = {
            
            let contentView = UIView()
            contentView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
            
            let backgroundView = UIView()
            backgroundView.frame = CGRect(x: 40, y: 0, width: width, height: height)
            contentView.addSubview(backgroundView)
            
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x383848).cgColor,UIColor.rgbColor(rgbValue: 0x22222c).cgColor]
            gradientLayer.locations = [0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
            gradientLayer.cornerRadius = 5
            backgroundView.layer.insertSublayer(gradientLayer, at: 0)
            
            
            
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: width, height: 100)
            //label.center = view.center
            label.text = "注意"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.textColor = JXTextColor
            backgroundView.addSubview(label)
            
            
            
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: 24, y: label.jxBottom + 20, width: width - 24 * 2, height: 45)
            nameLabel.text = "修改资金密码后，1小时内将无法进行挂卖与支付操作。"
            nameLabel.textColor = JXTextColor
            nameLabel.font = UIFont.systemFont(ofSize: 16)
            nameLabel.textAlignment = .center
            nameLabel.numberOfLines = 0
            
            backgroundView.addSubview(nameLabel)
            nameLabel.center.y = backgroundView.center.y
            
            
            let margin : CGFloat = 16
            let space : CGFloat = 24
            let buttonWidth : CGFloat = (width - 16 * 2)
            let buttonHeight : CGFloat = 44
            
            
            let button = UIButton()
            button.frame = CGRect(x: margin, y: height - space - buttonHeight, width: buttonWidth, height: buttonHeight)
            button.setTitle("我已知晓风险，确认进行下一步", for: .normal)
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(confirm1), for: .touchUpInside)
            backgroundView.addSubview(button)
            
            
            button.layer.cornerRadius = 2
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 10
            button.layer.shadowOffset = CGSize(width: 0, height: 10)
            button.layer.shadowColor = JX10101aShadowColor.cgColor
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.backgroundColor = JXOrangeColor
            
            return contentView
        }()
        
        self.noticeView?.show()
    }
    @objc func hideNoticeView1() {
        self.noticeView?.dismiss()
    }
    @objc func confirm1() {
        self.hideNoticeView1()
        
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
