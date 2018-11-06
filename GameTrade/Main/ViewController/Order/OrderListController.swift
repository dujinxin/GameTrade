//
//  OrderListController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/10/17.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIdentifiering = "reuseIdentifiering"
private let reuseIdentifiered = "reuseIdentifiered"

class OrderListController: JXTableViewController {
    
    var vm = OrderVM()
    
    var countDown : CountDown?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "订单"
        
        self.tableView?.register(UINib(nibName: "OrderingListCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifiering")
        self.tableView?.register(UINib(nibName: "OrderedListCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifiered")
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
        
        //每次进入都刷新，则不用监听登录状态
        //NotificationCenter.default.addObserver(self, selector: #selector(loginStatus(notify:)), name: NSNotification.Name(rawValue: NotificationLoginStatus), object: nil)
        
        //self.countDown = CountDown(tableView: self.tableView!, data: self.vm.orderListEntity.listArray)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.mj_header.beginRefreshing()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.countDown?.timer.suspend()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    deinit {
        
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
        
        self.vm.orderList(pageNo: page) { (_, msg, isSuc) in
            self.tableView?.mj_header.endRefreshing()
            if isSuc {

                self.tableView?.reloadData()
                self.countDown = CountDown(tableView: self.tableView!, data: self.vm.orderListEntity.listArray)
                self.countDown?.completionBlock = { indexPath in
                    self.tableView?.reloadRows(at: [indexPath], with: .automatic)
                }
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
}
extension OrderListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.vm.orderListEntity.listArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = self.vm.orderListEntity.listArray[indexPath.row]
        //付款状态，1：待付款，2：待确认付款，3：已完成，4：未付款取消，5：财务判断取消,6：超时系统自动取消
        if let type = entity.orderType ,((type == "购买" && entity.orderStatus == 1) || (type == "出售" && entity.orderStatus == 2)){
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifiering", for: indexPath) as! OrderingListCell
            cell.tag = indexPath.row
            cell.entity = entity
            if type == "购买" {
                cell.buyButton.setTitle(countDown?.countDown(indexPath: indexPath), for: .normal)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifiered", for: indexPath) as! OrderedListCell
            cell.tag = indexPath.row
            let entity = self.vm.orderListEntity.listArray[indexPath.row]
            cell.entity = entity
            return cell
        }
//        if entity.orderStatus == 1 || entity.orderStatus == 2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifiering", for: indexPath) as! OrderingListCell
//            cell.tag = indexPath.row
//            cell.entity = entity
//            cell.buyButton.setTitle(countDown?.countDown(indexPath: indexPath), for: .normal)
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifiered", for: indexPath) as! OrderedListCell
//            cell.tag = indexPath.row
//            let entity = self.vm.orderListEntity.listArray[indexPath.row]
//            cell.entity = entity
//            return cell
//        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let entity = self.vm.orderListEntity.listArray[indexPath.row]
        let vc = OrderDetailController()
        vc.id = entity.id
        vc.hidesBottomBarWhenPushed = true
        vc.backBlock = {
            self.tableView?.mj_header.beginRefreshing()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
