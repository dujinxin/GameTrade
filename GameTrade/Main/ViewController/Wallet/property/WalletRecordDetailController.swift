//
//  WalletRecordDetailController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/29.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

enum Type: Int {
    case paying
    case payed
    case transfer
}

private let reuseIdentifieringDetailPayed = "reuseIdentifieringDetailPayed"
private let reuseIdentifierAddress = "reuseIdentifierAddress"

class WalletRecordDetailController: JXTableViewController {
    
    var defaultArray: Array = [["title":"商品说明"],["title":"对方账户"],["title":"分类"],["title":"订单号"],["title":"交易单价"],["title":"交易数量"],["title":"创建时间"]]
    
    var type : Type = .paying
    var tradeEntity = TradeEntity()
    
    var vm = WalletVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "交易详情"
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        
        //self.tableView?.separatorStyle = .none
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.register(UINib(nibName: "WalletListPayingCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierNormal)
        self.tableView?.register(UINib(nibName: "WalletDetailPayedCell", bundle: nil), forCellReuseIdentifier: reuseIdentifieringDetailPayed)
        self.tableView?.register(UINib(nibName: "WalletAddressCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierAddress)
        self.tableView?.register(UINib(nibName: "LabelCell", bundle: nil), forCellReuseIdentifier: labelCellIdentifier)
        self.tableView?.separatorStyle = .none
        
        
        self.requestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func requestData() {
        self.vm.tradeDetail(type: tradeEntity.type, bizId: tradeEntity.bizId ?? "") { (_, msg, isSuc) in
            if isSuc {
                self.tableView?.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.defaultArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            if self.type == .paying {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierNormal, for: indexPath) as! WalletListPayingCell
                cell.MerchantNameLabel.text = configuration_merchantName
                //cell.methodLabel.text =
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifieringDetailPayed, for: indexPath) as! WalletDetailPayedCell
                
                //cell.nameLabel.text = dict["title"]
                return cell
            }
            
        } else if indexPath.row == 2{
            
            if self.type == .transfer {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierAddress, for: indexPath) as! WalletAddressCell
                
                //cell.nameLabel.text = dict["title"]
                return cell
            } else {
                let dict = self.defaultArray[indexPath.row - 1]
                
                let cell = tableView.dequeueReusableCell(withIdentifier: labelCellIdentifier, for: indexPath) as! LabelCell
                //cell.selectionStyle = .none
                cell.infoLabel.text = dict["title"]
                
                return cell
            }
            
        } else {
            let dict = self.defaultArray[indexPath.row - 1]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: labelCellIdentifier, for: indexPath) as! LabelCell
            //cell.selectionStyle = .none
            cell.nameLabel.text = dict["title"]
            
            if indexPath.row == 1 {
                cell.infoLabel.text = self.vm.tradeDetailEntity.goodsName
            } else if indexPath.row == 3 {
                cell.infoLabel.text = self.vm.tradeDetailEntity.type
            } else if indexPath.row == 4 {
                cell.infoLabel.text = "订单号"
            } else if indexPath.row == 5 {
                cell.infoLabel.text = "\(self.vm.tradeDetailEntity.price) \(configuration_valueType)"
            } else if indexPath.row == 6 {
                cell.infoLabel.text = "\(self.vm.tradeDetailEntity.amount) \(configuration_coinName)"
            } else if indexPath.row == 7 {
                cell.infoLabel.text = self.vm.tradeDetailEntity.createTime
            }
            
            return cell
        }
        //}
        //return UITableViewCell()
    }
   
}
