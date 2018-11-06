//
//  NewOrderDetailController.swift
//  GameTrade
//
//  Created by 杜进新 on 2018/11/5.
//  Copyright © 2018年 dujinxin. All rights reserved.
//

import UIKit

private let reuseIndentifierHeaderBuying = "reuseIndentifierHeaderBuying"
private let reuseIndentifierHeaderBuyed = "reuseIndentifierHeaderBuyed"
private let reuseIndentifierHeaderSelling = "reuseIndentifierHeaderSelling"
private let reuseIndentifierHeaderSelled = "reuseIndentifierHeaderSelled"

class OrderDetailController: JXTableViewController {

    var vm = OrderVM()
    var id : String?
    var comeFrom = 0 //默认为订单列表待确认付款状态直接进来
    
    var timer : DispatchSourceTimer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "订单详情"
        
        self.tableView?.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        // Register cell classes
        self.tableView?.register(UINib(nibName: "OrderBuyingDetailCell", bundle: nil), forCellReuseIdentifier: reuseIndentifierHeaderBuying)
        self.tableView?.register(UINib(nibName: "OrderBuyedDetailCell", bundle: nil), forCellReuseIdentifier: reuseIndentifierHeaderBuyed)
        self.tableView?.register(UINib(nibName: "OrderSellingDetailCell", bundle: nil), forCellReuseIdentifier: reuseIndentifierHeaderSelling)
        self.tableView?.register(UINib(nibName: "OrderSelledDetailCell", bundle: nil), forCellReuseIdentifier: reuseIndentifierHeaderSelled)

        self.requestData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let timer = self.timer {
            print("cancel...")
            timer.cancel()
        }
    }
    deinit {
    
    }
    @objc func loginStatus(notify:Notification) {
        print(notify)
        
        if let isSuccess = notify.object as? Bool,
            isSuccess == true{
            self.requestData()
        }
    }
    
    override func requestData() {
        
        self.vm.orderDetail(id: self.id ?? "") { (_, msg, isSuc) in
            self.tableView?.reloadData()
            
            self.resetNaviagationItem()
        }
    }
    func resetNaviagationItem() {
        //订单状态 1：待付款，2：待确认付款，3：已完成，4：未付款取消，5：财务判断取消,6：超时系统自动取消
        if self.vm.orderDetailEntity.orderStatus == 2 {
            self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-back"), style: .plain, target: self, action: #selector(backToRoot))
            self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(title: "申诉", fontSize: 14, imageName: "", target: self, action: #selector(backToRoot))
        }
    }
    @objc func backToRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc func appeal() {
        print("shengshu")
    }
}
extension OrderDetailController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //付款状态，1：待付款，2：待确认付款，3：已完成，4：未付款取消，5：财务判断取消,6：超时系统自动取消
        if self.vm.orderDetailEntity.orderType == "购买" {
            if self.vm.orderDetailEntity.orderStatus == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndentifierHeaderBuying, for: indexPath) as! OrderBuyingDetailCell
                cell.entity = self.vm.orderDetailEntity
                self.timer = cell.timer
                cell.cancelBlock = {
                    
                    self.vm.buyCancel(id: self.vm.orderDetailEntity.id, completion: { (_, msg, isSuc) in
                        if isSuc {
//                            if let block = self.backBlock {
//                                block()
//                            }
//                            self.navigationController?.popToRootViewController(animated: true)
                            self.requestData()
                        } else {
                            ViewManager.showNotice(msg)
                        }
                    })
                }
                cell.timeOutBlock = {
                    
                    print("timeOutBlock")
                    self.requestData()
                }
                cell.payBlock = {
                    //确认
                    self.vm.buyConfirm(id: self.vm.orderDetailEntity.id, completion: { (_, msg, isSuc) in
                        if isSuc {
//                            if let block = self.backBlock {
//                                block()
//                            }
//                            self.navigationController?.popToRootViewController(animated: true)
                            self.requestData()
                        } else {
                            ViewManager.showNotice(msg)
                        }
                    })
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndentifierHeaderBuyed, for: indexPath) as! OrderBuyedDetailCell
                cell.entity = self.vm.orderDetailEntity
                return cell
            }
        } else {
            if self.vm.orderDetailEntity.orderStatus == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndentifierHeaderSelling, for: indexPath) as! OrderSellingDetailCell
                cell.entity = self.vm.orderDetailEntity
                self.timer = cell.timer
                cell.cancelBlock = {
                    
                    self.vm.sellCancel(id: self.vm.orderDetailEntity.id, completion: { (_, msg, isSuc) in
                        if isSuc {
//                            if let block = self.backBlock {
//                                block()
//                            }
//                            self.navigationController?.popToRootViewController(animated: true)
                            self.requestData()
                        } else {
                            ViewManager.showNotice(msg)
                        }
                    })
                }
                cell.timeOutBlock = {
                    
                    print("timeOutBlock")
                    self.requestData()
                }
                cell.payBlock = {
                    //确认
                    self.vm.sellConfirm(id: self.vm.orderDetailEntity.id, completion: { (_, msg, isSuc) in
                        if isSuc {
//                            if let block = self.backBlock {
//                                block()
//                            }
//                            self.navigationController?.popToRootViewController(animated: true)
                            self.requestData()
                        } else {
                            ViewManager.showNotice(msg)
                        }
                    })
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIndentifierHeaderSelled, for: indexPath) as! OrderSelledDetailCell
                cell.entity = self.vm.orderDetailEntity
                return cell
            }
        }
    }
}
