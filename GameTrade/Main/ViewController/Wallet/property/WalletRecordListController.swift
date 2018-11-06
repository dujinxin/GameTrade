//
//  WalletRecordListController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/29.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIdentifiering = "reuseIdentifiering"
private let reuseIdentifiered = "reuseIdentifiered"

class WalletRecordListController: JXTableViewController {
    
    var vm = WalletVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "钱包记录"
        
        self.tableView?.register(UINib(nibName: "WalletListPayingCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifiering")
        self.tableView?.register(UINib(nibName: "WalletListPayedCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifiered")
        self.tableView?.register(UINib(nibName: "WalletListTransferCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierNormal)
        self.tableView?.estimatedRowHeight = 121
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.separatorStyle = .none
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: self.page)
        })
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.request(page: self.page)
        })
        self.tableView?.mj_header.beginRefreshing()
        //每次进入都刷新，则不用监听登录状态
        //NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier {
//        case "invite":
//            if let vc = segue.destination as? InviteViewController, let inviteEntity = sender as? InviteEntity {
//                vc.inviteEntity = inviteEntity
//            }
//        default:
//            print("123456")
//        }
    }
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            self.tableView?.mj_header.beginRefreshing()
        }
    }
    override func request(page: Int) {
        self.vm.tradeList(pageNo: self.page) { (_, msg, isSuc) in
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()
            if isSuc {
                self.tableView?.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
}
extension WalletRecordListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.tradeListEntity.listArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = self.vm.tradeListEntity.listArray[indexPath.row]
        //1:买币，2:卖币，3:支付，4:收款，5:转账，6:手续费，当type为6时不可查看详情
//        if entity.type == 1 {
//
//        } else if entity.type == 1 {
//
//        } else if entity.type == 1 {
//
//        } else if entity.type == 1 {
//
//        } else if entity.type == 5 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierNormal, for: indexPath) as! WalletListTransferCell
//            //        let entity = self.vm.tradeListEntity.listArray[indexPath.row]
//            //        cell.entity = entity
//            return cell
//        } else {
//
//        }
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifiered, for: indexPath) as! WalletListPayedCell
            //        let entity = self.vm.tradeListEntity.listArray[indexPath.row]
            //        cell.entity = entity
            
            cell.entity = entity
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifiering, for: indexPath) as! WalletListPayingCell
            //        let entity = self.vm.tradeListEntity.listArray[indexPath.row]
            //        cell.entity = entity
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifiered, for: indexPath) as! WalletListPayedCell
            //        let entity = self.vm.tradeListEntity.listArray[indexPath.row]
            //        cell.entity = entity
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifiered, for: indexPath) as! WalletListPayedCell
            //        let entity = self.vm.tradeListEntity.listArray[indexPath.row]
            //        cell.entity = entity
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let entity = self.vm.tradeListEntity.listArray[indexPath.row]
        let vc = WalletRecordDetailController()
        vc.hidesBottomBarWhenPushed = true
        vc.tradeEntity = entity
        if indexPath.row == 0 {
            vc.type = .paying
        } else if indexPath.row == 1 {
            vc.type = .payed
        } else if indexPath.row == 2 {
            vc.type = .transfer
        } else {
            vc.type = .payed
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

