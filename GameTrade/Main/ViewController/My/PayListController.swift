//
//  PayListController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/18.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

let normalCellIdentifier : String = "normalCellIdentifier"
let emptyCellIdentifier : String = "emptyCellIdentifier"

class PayListController: JXTableViewController {

    var vm = PayVM()
    var defaultArray: Array = [["image":"icon-ali","title":"支付宝"],["image":"icon-wechat","title":"微信"],["image":"icon-card","title":"银行卡"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收款方式"
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        
        //self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.register(UINib(nibName: "PayNormalCell", bundle: nil), forCellReuseIdentifier: normalCellIdentifier)
        self.tableView?.register(UINib(nibName: "PayEmptyCell", bundle: nil), forCellReuseIdentifier: emptyCellIdentifier)
    
        self.requestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func requestData() {
        self.vm.payCustomList { (_, msg, isSuc) in
            self.tableView?.reloadData()
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dict = self.defaultArray[indexPath.item]
        
        
        
        if indexPath.row == 0 {
            if let entity = self.vm.customListEntity?.list["ali"], entity.isEmpty == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: normalCellIdentifier, for: indexPath) as! PayNormalCell
            
                cell.selectionStyle = .none
                cell.payImageView.image = UIImage(named: dict["image"]!)
                cell.payNameLabel.text = dict["title"]
                
                cell.editBlock = {
                    cell.setEditing(true, animated: true)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellIdentifier, for: indexPath) as! PayEmptyCell
                //cell.selectionStyle = .none
                cell.payImageView.image = UIImage(named: dict["image"]!)
                cell.payNameLabel.text = dict["title"]
                return cell
            }
            
        } else if indexPath.row == 1{
            if let entity = self.vm.customListEntity?.list["weChat"], entity.isEmpty == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: normalCellIdentifier, for: indexPath) as! PayNormalCell
                
                cell.selectionStyle = .none
                cell.payImageView.image = UIImage(named: dict["image"]!)
                cell.payNameLabel.text = dict["title"]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellIdentifier, for: indexPath) as! PayEmptyCell
                //cell.selectionStyle = .none
                cell.payImageView.image = UIImage(named: dict["image"]!)
                cell.payNameLabel.text = dict["title"]
                return cell
            }
        } else {
            if let entity = self.vm.customListEntity?.list["card"], entity.isEmpty == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: normalCellIdentifier, for: indexPath) as! PayNormalCell
                
                cell.payImageView.image = UIImage(named: dict["image"]!)
                cell.payNameLabel.text = dict["title"]
                cell.entity = entity
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellIdentifier, for: indexPath) as! PayEmptyCell
                //cell.selectionStyle = .none
                cell.payImageView.image = UIImage(named: dict["image"]!)
                cell.payNameLabel.text = dict["title"]
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            
            if let entity = self.vm.customListEntity?.list["ali"], entity.isEmpty == 0 {
                return true
            }
            
        } else if indexPath.row == 1 {
            if let entity = self.vm.customListEntity?.list["weChat"], entity.isEmpty == 0 {
                return true
            }
        } else {
            if let entity = self.vm.customListEntity?.list["card"], entity.isEmpty == 0 {
                return true
            }
        }
        return false
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除！"
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        let style : UITableViewCellEditingStyle = .delete
        return style
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "netPay") as! NetPayController
            vc.hidesBottomBarWhenPushed = true
            vc.type = 1
            vc.backBlock = {
                //tableView.reloadRows(at: [indexPath], with: .automatic)
                self.requestData()
            }
            if let entity = self.vm.customListEntity?.list["ali"], entity.isEmpty == 0 {
                vc.entity = entity
                vc.isEdit = true
            } else {
                vc.isEdit = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        } else if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "netPay") as! NetPayController
            vc.hidesBottomBarWhenPushed = true
            vc.type = 2
            vc.backBlock = {
                //tableView.reloadRows(at: [indexPath], with: .automatic)
                self.requestData()
            }
            if let entity = self.vm.customListEntity?.list["weChat"], entity.isEmpty == 0 {
                vc.entity = entity
                vc.isEdit = true
            } else {
                vc.isEdit = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "cardPay") as! CardPayController
            
            vc.hidesBottomBarWhenPushed = true
            vc.backBlock = {
                //tableView.reloadRows(at: [indexPath], with: .automatic)
                self.requestData()
            }
            if let entity = self.vm.customListEntity?.list["card"], entity.isEmpty == 0 {
                vc.entity = entity
                vc.isEdit = true
            } else {
                vc.isEdit = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //default,destructive默认红色，normal默认灰色，可以通过backgroundColor 修改背景颜色，backgroundEffect 添加模糊效果
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
            print("删除")
            //            let model = self.dataArray[indexPath.row] as! DBUserModel
            //            if JXBaseDB.default.deleteData(condition: ["id = \(model.id)"]) == true{
            //                self.dataArray.remove(at: indexPath.row)
            //                tableView.beginUpdates()
            //                tableView.deleteRows(at: [indexPath], with: .automatic)
            //                tableView.endUpdates()
            //            }
            var en = PayEntity()
            
            if indexPath.row == 0 {
                if let entity = self.vm.customListEntity?.list["ali"]{
                    en = entity
                }
            } else if indexPath.row == 1 {
                if let entity = self.vm.customListEntity?.list["weChat"]{
                    en = entity
                }
            } else  {
                if let entity = self.vm.customListEntity?.list["card"]{
                    en = entity
                }
            }
            
            self.vm.deletePay(id: en.id ?? "", payType: (indexPath.row + 1), completion: { (_, msg, isSuc) in
                if isSuc {
                    self.requestData()
                }
            })
        }
        let markAction = UITableViewRowAction(style: .default, title: "编辑") { (action, indexPath) in
            print("编辑")
            self.editActionsForRowAt(indexPath: indexPath)
        }
        let cancelAction = UITableViewRowAction(style: .normal, title: "取消") { (action, indexPath) in
            //
            print("取消")
        }
        markAction.backgroundColor = JXGreenColor
        deleteAction.backgroundColor = JXRedColor
        cancelAction.backgroundColor = JXOrangeColor
        return [deleteAction,cancelAction,markAction]
    }
    func editActionsForRowAt(indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "netPay") as! NetPayController
            vc.hidesBottomBarWhenPushed = true
            vc.type = 1
            vc.backBlock = {
                //tableView.reloadRows(at: [indexPath], with: .automatic)
                self.requestData()
            }
            if let entity = self.vm.customListEntity?.list["ali"], entity.isEmpty == 0 {
                vc.entity = entity
                vc.isEdit = true
            } else {
                vc.isEdit = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "netPay") as! NetPayController
            vc.hidesBottomBarWhenPushed = true
            vc.type = 2
            vc.backBlock = {
                //tableView.reloadRows(at: [indexPath], with: .automatic)
                self.requestData()
            }
            if let entity = self.vm.customListEntity?.list["weChat"], entity.isEmpty == 0 {
                vc.entity = entity
                vc.isEdit = true
            } else {
                vc.isEdit = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "cardPay") as! CardPayController
            
            vc.hidesBottomBarWhenPushed = true
            vc.backBlock = {
                //tableView.reloadRows(at: [indexPath], with: .automatic)
                self.requestData()
            }
            if let entity = self.vm.customListEntity?.list["card"], entity.isEmpty == 0 {
                vc.entity = entity
                vc.isEdit = true
            } else {
                vc.isEdit = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
