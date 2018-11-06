//
//  ConfirmListController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/2.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

class ConfirmListController: JXTableViewController {
    
    var defaultArray: Array = [["title":"交易金额"],["title":"交易单价"],["title":"交易数量"],["title":"支付方式"]]
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 30, y: 0, width: 200, height: 44)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("添加", for: .normal)
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.addTarget(self, action: #selector(addOrder), for: .touchUpInside)
        button.backgroundColor = JXOrangeColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        
        //self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = 44//UITableViewAutomaticDimension
        self.tableView?.register(UINib(nibName: "SellTextFieldCell", bundle: nil), forCellReuseIdentifier: textCellIdentifier)
        self.tableView?.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: labelCellIdentifier)
        
        self.button.frame = CGRect(x: 30, y: 0, width: kScreenWidth - 30 * 2, height: 44)
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44))
        footer.addSubview(self.button)
        self.tableView?.tableFooterView = footer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.defaultArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = self.defaultArray[indexPath.row]
        if self.defaultArray.count > indexPath.row {
            if indexPath.row == 1 || indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! SellTextFieldCell
                cell.selectionStyle = .none
                
                cell.nameLabel.text = dict["title"]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: labelCellIdentifier, for: indexPath) as! LabelCell
                //cell.selectionStyle = .none
                cell.infoLabel.text = dict["title"]
                
                if indexPath.row == self.defaultArray.count - 1{
                    cell.accessoryType = .disclosureIndicator
                }
                return cell
                
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "netPay") as! NetPayController
            vc.hidesBottomBarWhenPushed = true
            //vc.type = .tab
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 1 {
            
        } else {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "cardPay") as! CardPayController
            vc.hidesBottomBarWhenPushed = true
            //vc.type = .tab
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func addOrder() {
        print("T##items: Any...##Any")
    }
}
